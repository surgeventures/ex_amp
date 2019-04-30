defmodule ExAmp.HexPackage do
  @moduledoc false

  def get_version(name) when is_atom(name) do
    get_version(to_string(name))
  end

  def get_version(name) do
    with auth <- Mix.Tasks.Hex.auth_info(:read, auth_inline: false),
         {:ok, {200, packages, _}} <- Hex.API.Package.search(nil, name, auth),
         %{"releases" => releases} <- Enum.find(packages, &(&1["name"] == name)),
         %{"version" => version} = Enum.find(releases, &Hex.Version.stable?(&1["version"])) do
      {:ok, version}
    else
      _ -> :error
    end
  end
end
