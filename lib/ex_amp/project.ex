defmodule ExAmp.Project do
  @moduledoc false

  def config do
    Mix.Project.config()
  end

  def config_path do
    "mix.exs"
  end

  def app do
    config() |> Keyword.fetch!(:app)
  end

  def deps do
    config() |> Keyword.fetch!(:deps)
  end

  def github_repo_path do
    source_url = get_in(config(), [:docs, :source_url])

    case source_url do
      "https://github.com/" <> path -> path
      _ -> nil
    end
  end

  def package? do
    Keyword.has_key?(Mix.Project.config(), :package)
  end
end
