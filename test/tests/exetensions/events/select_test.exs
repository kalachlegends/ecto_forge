defmodule Tests.Exetensions.SelectTest do
  use ExUnit.Case

  use EctoForge.RepoCase
  alias EctoForgeTest.UserModel
  test "Test  EctoForge.Extension.Get.Select" do
    user = EctoForge.Repo.insert!(%UserModel{name: "artem"})

    assert {:ok, %UserModel{id: id, name: nil}} =
             UserModel.get(filter: %{id: user.id}, select: [:id])

    assert user.id == id

    assert {:ok, %UserModel{id: id, name: name}} =
             UserModel.get(filter: %{id: user.id}, select: [:name])

    assert user.name == name
    assert is_nil(id)
  end
end
