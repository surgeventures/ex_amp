defmodule ExAmp.Provision.Credo do
  @moduledoc false

  use ExAmp.Task

  @config_path ".credo.exs"

  @config_default """
  %{
    configs: [
      %{
        name: "default",
        files: %{
          included: ["lib/", "test/"]
        },
        strict: true,
        color: true,
        checks: [
          {Credo.Check.Readability.MaxLineLength, [max_length: 100]}
        ]
      }
    ]
  }
  """

  def gen do
    create_file(@config_path, @config_default)
  end
end
