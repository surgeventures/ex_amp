defmodule Xp.MixProject do
  use Mix.Project

  @origin_url "https://github.com/user-name/repo-name"

  def project do
    [
      app: :xp,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Add description",
      source_url: @origin_url,
      homepage_url: @origin_url,
      package: [
        licenses: ["MIT"],
        links: %{
          "Homepage" => @origin_url
        }
      ]
    ]
  end

  def application do
    [
      extra_applications: []
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0.5"},
      {:ex_doc, "~> 0.20.2", [only: [:dev, :test]]}
    ]
  end
end
