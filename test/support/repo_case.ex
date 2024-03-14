defmodule EctoForge.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias EctoForge.Repo

      import Ecto
      import Ecto.Query
      import EctoForge.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(EctoForge.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(EctoForge.Repo, {:shared, self()})
    end

    :ok
  end
end
