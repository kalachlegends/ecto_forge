defmodule EctoForge.Repo do
  use Ecto.Repo,
    otp_app: :ecto_forge,
    adapter: Ecto.Adapters.Postgres
end
