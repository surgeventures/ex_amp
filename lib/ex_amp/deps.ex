defmodule ExAmp.Deps do
  @moduledoc false

  use ExAmp.Task
  alias ExAmp.{HexPackage, Project}

  def add_latest(name, opts \\ []) do
    name =
      case name do
        string when is_binary(string) -> String.to_atom(string)
        atom when is_atom(atom) -> atom
      end

    add({name, :latest, opts})
  end

  defp add(dep) do
    dep_name = elem(dep, 0)

    log_step(:green, "adding dep", to_string(dep_name))

    with {_, false} <- {:already_added, Project.deps() |> List.keymember?(dep_name, 0)},
         content = File.read!(Project.config_path()),
         lines = String.split(content, "\n"),
         {_, {:ok, deps, last_dep_at, insert_dep_at}} <- {:parse_deps, parse_deps(lines)},
         {_, false} <- {:already_added, Enum.member?(deps, dep_name)},
         {_, {:ok, dep}} <- {:resolve_req, resolve_req(dep)} do
      lines =
        if last_dep_at do
          List.update_at(lines, last_dep_at, &String.replace(&1, ~r/(\s{4}{:.*})$/, "\\1,"))
        else
          lines
        end

      dep_string =
        dep
        |> Macro.escape()
        |> Macro.to_string()

      new_content =
        lines
        |> List.insert_at(insert_dep_at, dep_string)
        |> Enum.join("\n")
        |> Code.format_string!()

      File.write!(Project.config_path(), new_content)
      dep_req = elem(dep, 1)

      {:ok, :added, dep_req}
    else
      {:already_added, _} -> {:ok, :already_added}
      {:parse_deps, _} -> {:error, :parse_deps}
      {:resolve_req, _} -> {:error, :resolve_req}
    end
    |> case do
      {:error, :resolve_req} ->
        log_error("Unable to find package :#{dep_name} - please add it manually")

      {:error, :parse_deps, req} ->
        dep_string = "{:#{dep_name}, #{inspect(req)}}"
        log_error("Unable to modify project config - please add `#{dep_string}` to deps manually")

      {:ok, :added, _} ->
        nil

      {:ok, :already_added} ->
        nil
    end
  end

  defp resolve_req({name, :latest}), do: get_latest_version(name, [])
  defp resolve_req({name, :latest, opts}), do: get_latest_version(name, opts)
  defp resolve_req({_, _} = dep), do: {:ok, dep}
  defp resolve_req({name, req, []}), do: {:ok, {name, req}}
  defp resolve_req({_, _, _} = dep), do: {:ok, dep}

  defp get_latest_version(key, opts) do
    key
    |> HexPackage.get_version()
    |> case do
      {:ok, version} ->
        semver = Version.parse!(version)
        req = "~> #{semver.major}.#{semver.minor}.#{semver.patch}"

        dep =
          case opts do
            [] -> {key, req}
            opts_list -> {key, req, opts_list}
          end

        {:ok, dep}

      :error ->
        :error
    end
  end

  defp parse_deps(lines) do
    lines
    |> Enum.with_index()
    |> Enum.reduce(:no_func, fn
      {"  defp deps do", _}, :no_func ->
        :in_func

      {"    [" <> _, _}, :in_func ->
        {:in_list, [], nil}

      {"      {:" <> rest, at}, {:in_list, packages, _} ->
        [[package]] = Regex.scan(~r/^\w+/, rest)
        {:in_list, [String.to_atom(package) | packages], at}

      {"", _}, {:in_list, _, _} = acc ->
        acc

      {"      #" <> _, _}, {:in_list, _, _} = acc ->
        acc

      {"    ]" <> _, ends_at}, {:in_list, packages, last_at} ->
        {:after_list, packages, last_at, ends_at}

      _, {:in_list, _, _} ->
        :error

      {"  end", _}, {:after_list, packages, last_at, ends_at} ->
        {:ok, Enum.reverse(packages), last_at, ends_at}

      _, acc ->
        acc
    end)
    |> case do
      {:ok, _, _, _} = acc -> acc
      _ -> :error
    end
  end
end
