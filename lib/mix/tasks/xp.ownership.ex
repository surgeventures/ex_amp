defmodule Mix.Tasks.Xp.Ownership do
  @moduledoc """
  Manages package ownership on Hex as-a-code.

  ## List

  Lists all packages and their owners. Presents both owners defined in the ownership file and those
  already added on Hex. Colors the differences that would be applied with the `apply` command (where *green* means users that will be added on Hex, *red* - current Hex owners that will be removed).

      mix xp.ownership list

  ## Apply

  Syncs ownership between the ownership file and Hex, ie. adds or removes owners on Hex according to
  differences between the ownership file and actual state on Hex (that may be first introspected
  with the `list` command).

      HEX_API_KEY="<paste key from `mix hex.user key generate`>" mix xp.ownership apply

  ## Command line options

  * `--file OWNERSHIP_FILE` - The ownership file that should evaluate into a list of `{package_name,
    owner_email}` tuples, defaults to `.ownership.exs`
  """

  @shortdoc "Manages package ownership on Hex as-a-code"

  use Mix.Task
  alias XP.Ownership

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
