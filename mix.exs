defmodule WTTJ.MixProject do
  use Mix.Project

  def project do
    [
      app: :wttj,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [
        main_module: WTTJ.CLI,
        comment: "Show jobs statistics in CLI"
      ]
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
      {:poison, "~> 4.0"},
      {:geo, "~> 3.3"},
      {:nimble_csv, "~> 1.0"},
      {:topo, "~> 0.4.0"},
      {:table_rex, "~> 3.0.0"}
    ]
  end
end
