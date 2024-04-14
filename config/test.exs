import Config

config :ecto_forge, EctoForge.Repo,
  database: "ecto_forge#{System.get_env("MIX_TEST_PARTITION")}",
  username: "nov",
  password: "nov",
  hostname: "localhost",
  pool_size: 10,
  pool: Ecto.Adapters.SQL.Sandbox

config :ecto_forge, ecto_repos: [EctoForge.Repo]
