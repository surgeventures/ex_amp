defmodule Mix.Tasks.Amp.Deps.Add do
  @moduledoc """
  Adds latest version(s) of specified dep(s) to the project.

  Adding dependencies to Elixir project comes down to a simple task of inserting a tuple with
  package name and semantic version requirement string to the project configuration. Usually though,
  you'll want to add latest version of Hex package to the project and allow non-breaking changes.
  This requires checking the latest versions on Hex and manually adding the requirements. Such
  process can get time consuming especially when adding multiple deps.

  This task automates the whole process and allows quick (amd possibly batch) addition of deps to
  the project.

  ## Usage

  Task is invoked as follows:

      mix amp.deps.add PACKAGE [PACKAGE_2...]

  For example (single dep):

      mix amp.deps.add jason

  For example (multiple deps):

      mix amp.deps.add ecto ecto_sql postgrex

  """

  @shortdoc "Adds latest version(s) of specified dep(s) to the project"

  use Mix.Task
  alias ExAmp.Deps

  @switches []

  @impl true
  def run(args) do
    Hex.start()

    {_, args} = OptionParser.parse!(args, strict: @switches)

    for name <- args, do: Deps.add_latest(name)
  end
end
