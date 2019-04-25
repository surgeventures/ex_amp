defmodule Mix.Tasks.Xp.Gen.CleanCompile do
  use Mix.Task

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, _} = Hex.OptionParser.parse!(args, strict: @switches)

    Xp.gen_ci_task("mix compile --warnings-as-errors")
  end
end
