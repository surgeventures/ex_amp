defmodule Mix.Tasks.Xp.Dep do
  @moduledoc """
  Adds a project dependency with requirement pointing at latest or specified version.

  ## Usage

  Task is invoked with PACKAGE name and an optional VERSION (defaults to latest on Hex):

      mix xp.dep PACKAGE [VERSION]

  Add latest version:

      mix xp.dep ecto

  Add specific version:

      mix xp.dep ecto 3.1.2

  """

  @shortdoc "Adds a project dependency with requirement pointing at latest or specified version"

  use Mix.Task
  import XP.Gen

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, args} = OptionParser.parse!(args, strict: @switches)

    case args do
      [name] ->
        gen_latest_dep(name)

      [name, version] ->
        gen_dep({name, version})
    end
  end
end
