defmodule SheetGenie.MixProject do
  use Mix.Project

  def project do
    [
      app: :sheet_genie,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: SheetGenie.CLI],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :eex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixlsx, "~> 0.6.0"},
      {:httpoison, "~> 2.2.1"},
      {:jason, "~> 1.4.1"}
    ]
  end
end
