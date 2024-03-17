defmodule Tests.Databaseapi.UpdateOrInsertTest do
  use ExUnit.Case

  use EctoForge.RepoCase
  alias EctoForgeTest.UserModel

  test "test Update_or_insert" do
    assert %UserModel{id: id, name: "arte"} =
             UserModel.update_or_create!(%{filter: %{name: "arte"}}, %{name: "arte"})

    assert %UserModel{id: id, name: "artems"} =
             UserModel.update_or_create!(%{filter: %{name: "arte"}}, %{name: "artems"})
  end
end
