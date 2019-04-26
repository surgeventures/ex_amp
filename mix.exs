defmodule Xp.MixProject do
  use Mix.Project

  @github_url "https://github.com/surgeventures/xp"

  def project do
    [
      app: :xp,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Elixir package provisioning & maintenance on steroids",
      source_url: @github_url,
      homepage_url: @github_url,
      package: [
        licenses: ["MIT"],
        links: %{
          "GitHub" => @github_url
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
