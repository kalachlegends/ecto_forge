defmodule EctoForge.ApplicationTest do
  use Application

  def start(_type, _args) do
    children = [
      EctoForge.Repo
    ]

    opts = [strategy: :one_for_one, name: SimpleQueue.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
