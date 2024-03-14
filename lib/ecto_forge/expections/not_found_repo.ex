defmodule EctoForge.Expections.RepoNotFound do
  @moduledoc """
  ## when not found repo in `EctoForge.DatabaseApi`
  """
  defexception message: "Repo not found", status: 500
end
