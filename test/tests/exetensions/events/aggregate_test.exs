defmodule EctoForgeTest.Extensions.Aggregate do
  use ExUnit.Case

  use EctoForge.RepoCase
  alias EctoForgeTest.UserModel

  test "Test  EctoForge.Extension.Get.Aggregate" do
    assert {query, %{}} =
             EctoForge.Extension.Get.Aggregate.before_query_add_extension_to_get(
               UserModel,
               :one,
               EctoForge.Repo,
               [],
               from(user in UserModel, select: user),
               nil
             )

    assert {:result, 0, query, %{}} =
             EctoForge.Extension.Get.Aggregate.before_query_add_extension_to_get(
               UserModel,
               :all,
               EctoForge.Repo,
               [],
               from(user in UserModel, select: user),
               %{aggregate: %{field: :id}}
             )
  end
end
