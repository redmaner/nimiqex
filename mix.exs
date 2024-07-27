defmodule Nimiqex.MixProject do
  use Mix.Project

  def project do
    [
      app: :nimiqex,
      version: "0.8.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
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
      {:jsonrpc, "~> 0.2.0", hex: :finch_jsonrpc},
      {:inflex, "~> 2.1"},
      {:ex_doc, "~> 0.25.5", only: [:dev], runtime: false},
      {:blake2, "~> 1.0"},
      {:ed25519, "~> 1.4"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
