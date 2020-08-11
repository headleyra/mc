defmodule Mc.MixProject do
  use Mix.Project

  def project do
    [
      app: :mc,
      version: "0.19.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Mc.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:floki, "~> 0.26.0"},
      {:httpoison, "~> 1.6.2"},
      {:jason, "~> 1.1.2"},
      {:elixir_uuid, "~> 1.2"},
      {:tesla, "~> 1.3.3"},
      {:mongodb, "~> 0.5.1"}

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
