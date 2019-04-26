defmodule Mix.Tasks.Xp.Gen.Ci do
  @shortdoc "Generates a complete continuous integration setup (uses CircleCI)"
  @moduledoc @shortdoc

  use Mix.Task

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, _} = Hex.OptionParser.parse!(args, strict: @switches)

    Xp.Gen.gen_ci_config()
  end
end
