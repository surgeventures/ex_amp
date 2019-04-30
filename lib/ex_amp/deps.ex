defmodule ExAmp.Deps do
  @moduledoc false

  use ExAmp.Task
  alias ExAmp.{HexPackage, Project}

  def add_latest(name, opts \\ []) do
    log_step(:green, "adding dep", name)

    name
    |> HexPackage.get_version()
    |> case do
      {:ok, version} ->
        semver = Version.parse!(version)
        req = "~> #{semver.major}.#{semver.minor}.#{semver.patch}"
        key = String.to_atom(name)

        dep =
          case opts do
            [] -> {key, req}
            opts_list -> {key, req, opts_list}
          end

        case gen_dep_quiet(dep) do
          :error -> {:error, :gen_dep, req}
          misc -> misc
        end

      :error ->
        {:error, :get_package_version}
    end
    |> log_result(name)
  end

  def add(dep) do
    name = elem(dep, 0)

    log_step(:green, "adding dep", name)

    dep
    |> gen_dep_quiet()
    |> log_result(name)
  end

  defp gen_dep_quiet(dep) do
    dep_name = elem(dep, 0)
    dep_req = elem(dep, 1)
    dep_string = dep |> Macro.escape() |> Macro.to_string()

    with {_, false} <- {:already_added, Project.deps() |> List.keymember?(dep_name, 0)},
         content = File.read!(Project.config_path()),
         lines = String.split(content, "\n"),
         {_, {:ok, deps, last_dep_at, insert_dep_at}} <- {:parse_deps, parse_deps(lines)},
         {_, false} <- {:already_added, Enum.member?(deps, dep_name)} do
      lines =
        if last_dep_at do
          List.update_at(lines, last_dep_at, &String.replace(&1, ~r/(\s{4}{:.*})$/, "\\1,"))
        else
          lines
        end

      new_content =
        lines
        |> List.insert_at(insert_dep_at, dep_string)
        |> Enum.join("\n")
        |> Code.format_string!()

      File.write!(Project.config_path(), new_content)

      {:ok, :added, dep_req}
    else
      {:already_added, _} -> {:ok, :already_added}
      {:parse_deps, _} -> {:error, :parse_deps}
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

  defp log_result(result, name) do
    case result do
      {:error, :get_package_version} ->
        log_info("Unable to find latest version of package :#{name} - please add it manually")

      {:error, :gen_dep, req} ->
        dep_string = "{:#{name}, #{inspect(req)}}"
        log_info("Unable to modify project config - please add `#{dep_string}` to deps manually")

      {:ok, :added, _} ->
        nil

      {:ok, :already_added} ->
        nil
    end

    result
  end
end
