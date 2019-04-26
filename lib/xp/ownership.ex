defmodule Xp.Ownership do
  @moduledoc false

  use Xp.Task

  @default_ownership_file ".ownership.exs"

  def list(opts \\ []) do
    package_owners = get_package_owners(opts)

    Enum.each(package_owners, fn {package, owners} ->
      log_info([:cyan, "#{package}"])
      Enum.each(owners, &log_owner/1)
      log_info([])
    end)
  end

  defp log_owner(owner) do
    {prefix, color} =
      case owner.hex_status do
        :add -> {" + ", :green}
        :remove -> {" + ", :yellow}
        :update_level -> {" ~ ", :magenta}
        :ok -> {"   ", :reset}
      end

    log_info([color, prefix <> owner.email])
  end

  def apply(opts \\ []) do
    package_owners = get_package_owners(opts)

    Enum.each(package_owners, fn {package, owners} ->
      Enum.each(owners, fn
        %{hex_status: :add, email: email, level: level} ->
          log_step(:green, "adding package owner", "#{package} : #{email} : #{level}")
          Mix.Tasks.Hex.Owner.run(["add", to_string(package), email, "--level", to_string(level)])

        %{hex_status: :remove, email: email} ->
          log_step(:green, "removing package owner", "#{package} : #{email}")
          Mix.Tasks.Hex.Owner.run(["remove", to_string(package), email])

        %{hex_status: :update_level, email: email, level: level} ->
          log_step(:green, "updating package owner level", "#{package} : #{email}")
          Mix.Tasks.Hex.Owner.run(["remove", to_string(package), email])
          Mix.Tasks.Hex.Owner.run(["add", to_string(package), email, "--level", to_string(level)])

        %{hex_status: :ok} ->
          nil
      end)
    end)
  end

  defp get_package_owners(opts) do
    opts
    |> Keyword.get(:file, @default_ownership_file)
    |> get_ownership_tuples_from_file()
    |> merge_defined_and_hex_owners()
  end

  defp get_ownership_tuples_from_file(file) do
    file
    |> Code.eval_file()
    |> elem(0)
  end

  defp merge_defined_and_hex_owners(ownership_tuples) do
    ownership_tuples
    |> Enum.reduce(%{}, fn {package, owner, level}, acc ->
      owner_level = {owner, level}
      Map.update(acc, package, [owner_level], &[owner_level | &1])
    end)
    |> Enum.map(fn {package, defined_owners_levels} ->
      {package, build_owners(package, defined_owners_levels)}
    end)
  end

  defp build_owners(package, defined_owners_levels) do
    defined_owners_levels_map = Map.new(defined_owners_levels)
    defined_owners = Map.keys(defined_owners_levels_map)
    hex_owners_levels_map = get_hex_owners_levels_map(to_string(package))
    hex_owners = Map.keys(hex_owners_levels_map)
    hex_add = Enum.uniq(defined_owners -- hex_owners)
    hex_remove = Enum.uniq(hex_owners -- defined_owners)
    all_owners = (defined_owners ++ hex_owners) |> Enum.uniq() |> Enum.sort()

    Enum.map(all_owners, fn email ->
      defined_level = defined_owners_levels_map[email]
      hex_level = hex_owners_levels_map[email]

      hex_status =
        cond do
          Enum.member?(hex_add, email) -> :add
          Enum.member?(hex_remove, email) -> :remove
          defined_level != hex_level -> :update_level
          true -> :ok
        end

      %{
        email: email,
        level: defined_level,
        hex_status: hex_status
      }
    end)
  end

  defp get_hex_owners_levels_map(package) do
    auth = Mix.Tasks.Hex.auth_info(:read)

    case Hex.API.Package.Owner.get(nil, package, auth) do
      {:ok, {code, body, _headers}} when code in 200..299 ->
        body
        |> Enum.map(&{&1["email"], String.to_atom(&1["level"])})
        |> Map.new()

      _ ->
        nil
    end
  end
end
