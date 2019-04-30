defmodule Mix.Tasks.Amp.Provision do
  @moduledoc """
  Provisions Elixir package with all or specified enhancements.

  All your code should aim to be top quality, readable, understandable and maintainable throughout
  its entire lifecycle. Elixir ecosystem provides many mature, well-thought tools either built right
  into the language or closely integrated with it. This includes:

  - **compiler** ([mix compile], built-in) - produces compilation warnings that allow to early
    detect bugs & typos in the code eg. an attempt to call non-existing or deprecated function

  - **code formatter** ([mix format], built-in) - ensures that all the code follows the same basic
    formatting rules such as maximum number of chars in a line or function indentation

  - **code linter** ([Credo]) - ensures that all the code follows a further established set of
    software design, consistency, readability & misc rules and conventions (still statical)

  - **documentation generator** ([ExDoc]) - produces documentation compilation errors on issues that
    make it impossible to assemble the docs eg. compilation errors in doc attributes

  - **test runner** ([ExUnit], built-in) - starts the application in test mode and runs all runtime
    tests against it (defined as test modules or embedded in docs as doctests)

  This exhaustive set of tools gives a deep & thorough end-to-end control over code quality, but it
  takes experience to know them and time & effort to set them all up.

  This task allows to quickly provision all of these tools in any existing Mix project for instant
  usage in a single shot. In addition to making checks available for local development, this task
  provides an out-of-the-box CI configuration that runs them in the cloud (free for open source),
  providing an instant & reliable indication as to whether released & pull requested code passes the
  established quality standards.

  ## Enhancements

  Following enhancements are available:

  - `ci` - complete continuous integration setup (uses CircleCI)
  - `no_warn` - check for compilation without warnings
  - `format` - check for code being properly formatted
  - `credo` - complete Credo static code linter setup
  - `docs` - complete ExDoc project documentation setup
  - `test` - check for passing ExUnit test suite

  Although not strictly required, they're applied in the above logical order so that CI config is
  available for further patching and the task order is optimized for fail-fast execution.

  ## Command line options

  * `--only ci,formatter` - apply only specific enhancements
  * `--except credo,docs` - apply all enhancements except specific ones

  [mix compile]: https://hexdocs.pm/mix/Mix.Tasks.Compile.Elixir.html
  [mix format]: https://hexdocs.pm/mix/master/Mix.Tasks.Format.html
  [Credo]: https://hexdocs.pm/credo
  [ExDoc]: https://hexdocs.pm/ex_doc
  [ExUnit]: https://hexdocs.pm/ex_unit
  """

  @shortdoc "Provisions Elixir package with all or specified enhancements"

  use Mix.Task
  alias ExAmp.Provision

  @switches [only: :string, except: :string]

  @all_enhancements ~w[ci no_warn format credo docs test]a

  @impl true
  def run(args) do
    Hex.start()

    {opts, _} = OptionParser.parse!(args, strict: @switches)

    enhancements = parse_enhancements(opts)

    for e <- enhancements, do: Provision.apply(e)
  end

  defp parse_enhancements(opts) do
    only_enhancements =
      opts
      |> Keyword.get_lazy(:only, fn -> Enum.join(@all_enhancements, ",") end)
      |> String.split(",")
      |> Enum.map(&String.to_atom/1)

    except_enhancements =
      opts
      |> Keyword.get(:except, "")
      |> String.split(",")
      |> Enum.map(&String.to_atom/1)

    @all_enhancements
    |> Enum.filter(&Enum.member?(only_enhancements, &1))
    |> Enum.reject(&Enum.member?(except_enhancements, &1))
  end
end
