defmodule EctoForgeTest do
  use ExUnit.Case

  use EctoForge.RepoCase
  alias EctoForgeTest.UserModel

  test "Test create instanse and get filtering" do
    user = EctoForge.Repo.insert!(%UserModel{name: "arte"})

    assert {:ok, user} = UserModel.get(name: "arte1", preload: [:user])
    assert %UserModel{} = user
  end

  test "test create update options" do
    assert {:ok, user} = UserModel.create(%{name: "arte1"})
    assert %UserModel{} = user
  end

  test "test context with on_created delete exite" do
    assert {:ok, user} = User.Context.create(%{name: "arte1"})
    assert %UserModel{} = user |> IO.inspect(label: "test/ecto_forge_test.exs:21")
    assert is_nil(Map.get(user, :id))
  end
end
