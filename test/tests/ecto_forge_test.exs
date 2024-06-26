defmodule EctoForgeTest do
  use ExUnit.Case

  use EctoForge.RepoCase
  alias EctoForgeTest.UserModel

  test "Test create instanse and get filtering" do
    user = EctoForge.Repo.insert!(%UserModel{name: "arte"})

    assert {:error, :not_found} = UserModel.get(filter: %{name: "arte1"}, preload: [:posts])
    assert %UserModel{} = user
  end

  test "Test get_all" do
    user = EctoForge.Repo.insert!(%UserModel{name: "arte"})

    assert [%UserModel{}] = UserModel.get_all!()
  end

  test "Test aggregate" do
    user = EctoForge.Repo.insert!(%UserModel{name: "arte"})

    assert 1 == UserModel.get_all!(%{filter: %{name: "arte"}, aggregate: %{field: :id}})
  end

  test "Test one nil" do
    user = EctoForge.Repo.insert!(%UserModel{name: "arte"})

    assert {:ok, [%UserModel{}]} = UserModel.get_all(filter: %{name: "arte"})

    user = EctoForge.Repo.insert!(%UserModel{name: "arte"})

    assert UserModel.get_all(filter: %{name: "artems"})
  end

  test "test create update options" do
    assert {:ok, user} = UserModel.create(%{name: "arte1"})
    assert %UserModel{} = user
  end

  test "test context with on_created delete exite" do
    assert {:ok, user} = User.Context.create(%{name: "arte1"})
    assert %UserModel{} = user
    assert is_nil(Map.get(user, :id))
  end

  test "test context fields" do
    assert [:id, :name] == User.Context.fields()
  end
end
