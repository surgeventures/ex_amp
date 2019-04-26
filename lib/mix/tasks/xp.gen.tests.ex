defmodule Mix.Tasks.Xp.Gen.Tests do
  @shortdoc "Generates a check for passing ExUnit test suite"
  @moduledoc @shortdoc

  use Mix.Task

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, _} = Hex.OptionParser.parse!(args, strict: @switches)

    Xp.Gen.gen_ci_task("mix test")
  end
end
