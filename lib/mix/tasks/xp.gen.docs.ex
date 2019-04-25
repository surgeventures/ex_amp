defmodule Mix.Tasks.Xp.Gen.Docs do
  use Mix.Task

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, _} = Hex.OptionParser.parse!(args, strict: @switches)

    Xp.gen_latest_dep("ex_doc", only: [:dev, :test])
    Xp.gen_ci_task("mix docs")
    Xp.gen_license()
  end
end
