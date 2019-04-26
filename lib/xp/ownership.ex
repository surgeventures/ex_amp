defmodule Xp.Ownership do
  @moduledoc false

  use Xp.Task

  @default_ownership_file ".ownership.exs"

  def list(opts \\ []) do
    package_owners = get_package_owners(opts)

    Enum.each(package_owners, fn
      {package, _, nil} ->
        log_error("Unknown package :#{package}")

      {package, defined_owners, hex_owners} ->
        log_info([:cyan, ":#{package}"])

        all_owners = (defined_owners ++ hex_owners) |> Enum.uniq() |> Enum.sort()
        {hex_add, hex_remove} = get_hex_owner_diff(defined_owners, hex_owners)

        Enum.each(all_owners, &log_owner(&1, hex_add, hex_remove))

        log_info([])
    end)
  end

  defp log_owner(owner, hex_add, hex_remove) do
    cond do
      Enum.member?(hex_add, owner) ->
        log_info([:green, " + " <> owner, :reset])

      Enum.member?(hex_remove, owner) ->
        log_info([:yellow, " - " <> owner, :reset])

      true ->
        log_info("   " <> owner)
    end
  end

  def apply(opts \\ []) do
    package_owners = get_package_owners(opts)

    Enum.each(package_owners, fn
      {package, _, nil} ->
        log_step(:red, "omitting unknown package", ":#{package}")

      {package, defined_owners, hex_owners} ->
        {hex_add, hex_remove} = get_hex_owner_diff(defined_owners, hex_owners)
        pkg = ":#{package}"

        Enum.each(hex_add, fn owner ->
          log_info([:green, "* adding owner ", :reset, owner, :green, " to package ", :cyan, pkg])
          Mix.Tasks.Hex.Owner.run(["add", to_string(package), owner])
        end)

        Enum.each(hex_remove, fn owner ->
          log_info([
            :green,
            "* removing owner ",
            :reset,
            owner,
            :green,
            " from package ",
            :cyan,
            pkg
          ])

          Mix.Tasks.Hex.Owner.run(["remove", to_string(package), owner])
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
    |> Enum.reduce(%{}, fn {package, owner}, acc ->
      Map.update(acc, package, [owner], &[owner | &1])
    end)
    |> Enum.map(fn {package, owners} ->
      {package, owners, get_hex_package_owners(to_string(package))}
    end)
  end

  defp get_hex_package_owners(package) do
    auth = Mix.Tasks.Hex.auth_info(:read)

    case Hex.API.Package.Owner.get(nil, package, auth) do
      {:ok, {code, body, _headers}} when code in 200..299 ->
        Enum.map(body, & &1["email"])

      _ ->
        nil
    end
  end

  defp get_hex_owner_diff(defined_owners, hex_owners) do
    hex_add = Enum.uniq(defined_owners -- hex_owners)
    hex_remove = Enum.uniq(hex_owners -- defined_owners)

    {hex_add, hex_remove}
  end
end
