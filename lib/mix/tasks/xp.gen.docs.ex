defmodule Mix.Tasks.Xp.Gen.Docs do
  @shortdoc "Generates a complete ExDoc project documentation setup"
  @moduledoc @shortdoc

  use Mix.Task

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, _} = Hex.OptionParser.parse!(args, strict: @switches)

    Xp.Gen.gen_latest_dep("ex_doc", only: [:dev, :test])
    Xp.Gen.gen_ci_task("mix docs")
    Xp.Gen.gen_license()
  end
end
