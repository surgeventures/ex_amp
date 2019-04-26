defmodule Mix.Tasks.Xp.Gen.All do
  @shortdoc "Provisions Elixir package with all enhancements (CI, linter, tests, docs...)"
  @moduledoc @shortdoc

  use Mix.Task

  @switches []

  alias Mix.Tasks.Xp.Gen.{
    Ci,
    CleanCompile,
    Credo,
    Docs,
    Formatter,
    Tests
  }

  @impl true
  def run(args) do
    Hex.start()

    {_, _} = Hex.OptionParser.parse!(args, strict: @switches)

    Ci.run([])
    Formatter.run([])
    Credo.run([])
    CleanCompile.run([])
    Docs.run([])
    Tests.run([])
  end
end
