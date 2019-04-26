defmodule Mix.Tasks.Xp.Gen.Formatter do
  @shortdoc "Generates a check for code being properly formatted"
  @moduledoc @shortdoc

  use Mix.Task

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, _} = Hex.OptionParser.parse!(args, strict: @switches)

    Xp.Gen.gen_formatter_config()
    Xp.Gen.gen_ci_task("mix format --check-formatted")
  end
end
