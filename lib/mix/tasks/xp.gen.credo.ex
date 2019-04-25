defmodule Mix.Tasks.Xp.Gen.Credo do
  use Mix.Task

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, _} = Hex.OptionParser.parse!(args, strict: @switches)

    Xp.gen_latest_dep("credo", only: [:dev, :test])
    Xp.gen_credo_config()
    Xp.gen_ci_task("mix credo")
  end
end
