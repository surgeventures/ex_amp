defmodule ExAmp.Provision.Formatter do
  @moduledoc false

  use ExAmp.Task

  @config_path ".formatter.exs"

  @config_default """
  [
    inputs: ["*.{ex,exs}", "{config,lib,test}/**/*.{ex,exs}"],
    line_length: 100
  ]
  """

  def gen do
    create_file(@config_path, @config_default)
  end
end
