defmodule Mix.Tasks.Xp.Gen.Dep do
  use Mix.Task

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, args} = Hex.OptionParser.parse!(args, strict: @switches)

    case args do
      [name] ->
        Xp.gen_latest_dep(name)

      [name, version] ->
        Xp.gen_dep({name, version})
    end
  end
end
