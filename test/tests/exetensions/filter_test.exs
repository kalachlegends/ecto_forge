defmodule EctoForgeTest.Extensions.Filter do
  use ExUnit.Case

  use EctoForge.RepoCase
  alias EctoForgeTest.UserModel

  test "Test  EctoForge.Extension.Get.Filter" do
    assert {query, %{}} =
             EctoForge.Extension.Get.Filter.before_query_add_extension_to_get(
               UserModel,
               :one,
               EctoForge.Repo,
               [],
               from(user in UserModel, select: user),
               %{filter: %{name: "artem"}}
             )

    assert query.wheres != 0

    assert {%Ecto.Query{}, %{}} =
             EctoForge.Extension.Get.Filter.before_query_add_extension_to_get(
               UserModel,
               EctoForge.Repo,
               [],
               :one,
               from(user in UserModel, select: user),
               nil
             )
  end
end
