defmodule EctoForge.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_forge,
      version: "0.1.4",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      aliases: aliases(),
      package: package(),
      description: description(),
      source_url: "https://github.com/kalachlegends/ecto_forge"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {EctoForge.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "EctoForge usising for filter query and create some context for Model Schema."
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:filtery, "~> 0.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      files: ~w(lib .formatter.exs mix.exs README*),
      name: "ecto_forge",
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/kalachlegends/ecto_forge"}
    ]
  end
end
