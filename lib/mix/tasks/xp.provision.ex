defmodule Mix.Tasks.Xp.Provision do
  @moduledoc """
  Provisions Elixir package with all or specified enhancements.

  ## Enhancements

  Following enhancements are available:

  - `ci` - complete continuous integration setup (uses CircleCI)
  - `no_warn` - check for compilation without warnings
  - `format` - check for code being properly formatted
  - `credo` - complete Credo static code linter setup
  - `docs` - complete ExDoc project documentation setup
  - `test` - check for passing ExUnit test suite

  Although not strictly required, they're applied in the above logical order so that CI config is
  available for further patching and the CI task order is optimized for fail-fast execution.

  ## Command line options

  * `--only ci,formatter` - Apply only specific enhancements (defaults to all)
  """

  @shortdoc "Provisions Elixir package with all or specified enhancements"

  use Mix.Task
  import Xp.Gen

  @switches [only: :string]

  @all_enhancements "ci,no_warn,format,credo,docs,test"

  @impl true
  def run(args) do
    Hex.start()

    {opts, _} = OptionParser.parse!(args, strict: @switches)

    enhancements =
      opts
      |> Keyword.get(:only, @all_enhancements)
      |> String.split(",")
      |> Enum.map(&String.to_atom/1)

    for e <- enhancements, do: apply(e)
  end

  defp apply(:ci) do
    gen_ci_config()
  end

  defp apply(:formatter) do
    gen_formatter_config()
    gen_ci_task("mix format --check-formatted")
  end

  defp apply(:credo) do
    gen_latest_dep("credo", only: [:dev, :test])
    gen_credo_config()
    gen_ci_task("mix credo")
  end

  defp apply(:no_warnings) do
    gen_ci_task("mix compile --warnings-as-errors")
  end

  defp apply(:docs) do
    gen_latest_dep("ex_doc", only: [:dev, :test])
    gen_ci_task("mix docs")
    gen_license()
  end

  defp apply(:test) do
    gen_ci_task("mix test")
  end
end
