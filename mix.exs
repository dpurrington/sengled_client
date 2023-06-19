defmodule SengledClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :sengled_client,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SengledClient.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gun, "~> 2.0"},
      {:websockex, "~> 0.4.3"},
      {:httpoison, "~> 2.0"},
      {:poison, "~> 5.0"}
    ]
  end
end
