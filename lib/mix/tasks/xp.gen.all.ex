defmodule Mix.Tasks.Xp.Gen.All do
  use Mix.Task

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, _} = Hex.OptionParser.parse!(args, strict: @switches)

    Mix.Tasks.Xp.Gen.Ci.run([])
    Mix.Tasks.Xp.Gen.Formatter.run([])
    Mix.Tasks.Xp.Gen.Credo.run([])
    Mix.Tasks.Xp.Gen.CleanCompile.run([])
    Mix.Tasks.Xp.Gen.Docs.run([])
    Mix.Tasks.Xp.Gen.Tests.run([])
  end
end
