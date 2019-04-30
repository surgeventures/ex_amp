defmodule ExAmp.Provision do
  @moduledoc false

  alias ExAmp.Deps
  alias ExAmp.Provision.{CI, Credo, Formatter, License, Readme}

  def apply(:ci) do
    CI.gen()
    Readme.add_badge(:ci)
  end

  def apply(:format) do
    Formatter.gen()
    CI.add_task("mix format --check-formatted")
  end

  def apply(:credo) do
    Deps.add_latest("credo", only: [:dev, :test])
    Credo.gen()
    CI.add_task("mix credo")
  end

  def apply(:no_warn) do
    CI.add_task("mix compile --warnings-as-errors")
  end

  def apply(:docs) do
    Deps.add_latest("ex_doc", only: [:dev, :test])
    CI.add_task("mix docs")
    Readme.gen()
    License.gen()
    Readme.add_badge(:license)
  end

  def apply(:test) do
    CI.add_task("mix test")
  end
end
