defmodule Mix.Tasks.Xp.Gen.Formatter do
  use Mix.Task

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, _} = Hex.OptionParser.parse!(args, strict: @switches)

    Xp.gen_formatter_config()
    Xp.gen_ci_task("mix format --check-formatted")
  end
end
