defmodule ExAmp.MixProject do
  use Mix.Project

  @github_url "https://github.com/surgeventures/ex-amp"

  def project do
    [
      app: :ex_amp,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "ExAmp",
      description: "Prepare, release and maintain your Elixir packages like a pro",
      package: [
        maintainers: ["Karol Słuszniak"],
        licenses: ["MIT"],
        links: %{
          "GitHub" => @github_url
        }
      ],
      docs: [
        main: "readme",
        source_url: @github_url,
        extras: ~w[README.md]
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
      {:credo, "~> 1.0.5", [only: [:dev, :test]]},
      {:ex_doc, "~> 0.20.2", [only: [:dev, :test]]}
    ]
  end
end
