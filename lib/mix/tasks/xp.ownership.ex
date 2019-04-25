defmodule Mix.Tasks.Xp.Ownership do
  use Mix.Task

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, args} = Hex.OptionParser.parse!(args, strict: @switches)

    case args do
      ["list"] ->
        package_owners = get_package_owners()

        Enum.each(package_owners, fn {package, defined_owners, hex_owners} ->
          all_owners = (defined_owners ++ hex_owners) |> Enum.uniq() |> Enum.sort()
          hex_add = defined_owners -- hex_owners
          hex_remove = hex_owners -- defined_owners

          owners_str =
            all_owners
            |> Enum.map(fn owner ->
              cond do
                Enum.member?(hex_add, owner) ->
                  " + " <> owner

                Enum.member?(hex_remove, owner) ->
                  " - " <> owner

                true ->
                  "   " <> owner
              end
            end)
            |> Enum.join("\n")

          Mix.shell().info(":#{package}\n#{owners_str}\n")
        end)

      ["apply"] ->
        package_owners = get_package_owners()

        Enum.each(package_owners, fn {package, defined_owners, hex_owners} ->
          hex_add = defined_owners -- hex_owners
          hex_remove = hex_owners -- defined_owners

          Enum.each(hex_add, fn owner ->
            Xp.log(:green, "adding owner", ":#{package} - #{owner}")
            Mix.Tasks.Hex.Owner.run(["add", to_string(package), owner])
          end)

          Enum.each(hex_remove, fn owner ->
            Xp.log(:green, "removing owner", ":#{package} - #{owner}")
            Mix.Tasks.Hex.Owner.run(["remove", to_string(package), owner])
          end)
        end)
    end
  end

  defp get_package_owners do
    {po_list, _} = Code.eval_file(".ownership.exs")

    Enum.reduce(po_list, %{}, fn {package, owner}, acc ->
      acc
      |> Map.put_new(package, [])
      |> Map.update(package, [], &[owner | &1])
    end)
    |> Enum.map(fn {package, owners} ->
      {package, owners, get_hex_package_owners(to_string(package))}
    end)
    |> Enum.filter(fn {_, _, hex_owners} -> hex_owners end)
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
end
