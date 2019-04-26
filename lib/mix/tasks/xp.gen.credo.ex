defmodule Mix.Tasks.Xp.Gen.Credo do
  @shortdoc "Generates a complete Credo static code linter setup"
  @moduledoc @shortdoc

  use Mix.Task

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, _} = Hex.OptionParser.parse!(args, strict: @switches)

    Xp.Gen.gen_latest_dep("credo", only: [:dev, :test])
    Xp.Gen.gen_credo_config()
    Xp.Gen.gen_ci_task("mix credo")
  end
end
