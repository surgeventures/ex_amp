defmodule Mix.Tasks.Xp.Gen.Tests do
  use Mix.Task

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, _} = Hex.OptionParser.parse!(args, strict: @switches)

    Xp.gen_ci_task("mix test")
  end
end
