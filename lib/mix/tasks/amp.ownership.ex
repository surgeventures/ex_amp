defmodule Mix.Tasks.Amp.Ownership do
  @moduledoc """
  Manages package ownership on Hex as a code.

  When the organization active with Elixir open source releases on Hex grows with more maintainers and growing number of packages, it may become a time consuming and error prone task to manage the
  package ownership. This task solves this problem by allowing to manage the ownership as a code.

  *Ownership file* serves the purpose of the source of truth. It should be a valid Elixir script
  that should evaluate into a list of `{package_name, owner_email}` tuples and it defaults to
  `.ownership.exs`.

  ## Usage

  ### List

  Lists all packages and their owners. Presents both owners defined in the ownership file and those
  already added on Hex. Colors the differences that would be applied with the `apply` command (where *green* means users that will be added on Hex, *red* - current Hex owners that will be removed).

      mix amp.ownership list

  ### Apply

  Syncs ownership between the ownership file and Hex, ie. adds or removes owners on Hex according to
  differences between the ownership file and actual state on Hex (that may be first introspected
  with the `list` command).

      HEX_API_KEY="<paste key from `mix hex.user key generate`>" mix amp.ownership apply

  ## Command line options

  * `--file OWNERSHIP_FILE` - path to the ownership file, defaults to `.ownership.exs`

  """

  @shortdoc "Manages package ownership on Hex as a code"

  use Mix.Task
  alias ExAmp.Ownership

  @switches [file: :string]

  @impl true
  def run(args) do
    Hex.start()

    {opts, args} = OptionParser.parse!(args, strict: @switches)

    case args do
      ["list"] ->
        Ownership.list(opts)

      ["apply"] ->
        Ownership.apply(opts)
    end
  end
end
