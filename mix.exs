defmodule SteinStorage.MixProject do
  use Mix.Project

  def project do
    [
      app: :stein_storage,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/smartlogic/stein_storage",
      homepage_url: "https://github.com/smartlogic/stein_storage",
      description: description(),
      package: package(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:hackney, "~> 1.15"},
      {:plug, "~> 1.7"}
    ]
  end

  def description() do
    """
    Stein.Storage contains common storage functions for our projects at SmartLogic.
    """
  end

  def package() do
    [
      maintainers: ["Eric Oestrich"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/smartlogic/stein_storage"}
    ]
  end
end
