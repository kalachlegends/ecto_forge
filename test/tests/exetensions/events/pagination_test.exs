defmodule EctoForgeTest.Extensions.PaginationTest do
  use ExUnit.Case

  use EctoForge.RepoCase
  alias EctoForgeTest.UserModel

  test "Test  EctoForge.Extension.Get.Pagination" do
    Enum.map(1..30, fn x -> EctoForge.Repo.insert!(%UserModel{name: "arte#{x}"}) end)

    assert {:ok, %{count_data: 30, data: data}} = UserModel.get_all(pagination: %{})
    assert is_list(data)
    assert length(data) == 10
    assert {:ok, %{count_data: 30, data: data}} = UserModel.get_all(pagination: %{page: 2})
    assert %UserModel{name: "arte11"} = data |> hd()
  end
end
