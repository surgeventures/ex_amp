defmodule Mix.Tasks.Xp.Gen.Dep do
  @shortdoc "Generates a new dependency with requirement pointing at latest version"
  @moduledoc @shortdoc

  use Mix.Task

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, args} = Hex.OptionParser.parse!(args, strict: @switches)

    case args do
      [name] ->
        Xp.Gen.gen_latest_dep(name)

      [name, version] ->
        Xp.Gen.gen_dep({name, version})
    end
  end
end
