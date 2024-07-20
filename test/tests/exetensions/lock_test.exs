defmodule EctoForgeTest.Extensions.Lock do
  use ExUnit.Case

  use EctoForge.RepoCase
  alias EctoForgeTest.UserModel
  @tag only: true
  test "Test  EctoForge.Extension.Get.Lock" do
    assert {query, %{}} =
             EctoForge.Extension.Get.Lock.before_query_add_extension_to_get(
               UserModel,
               :one,
               EctoForge.Repo,
               [],
               from(user in UserModel, select: user),
               %{lock: "FOR SHARE NOWAIT"}
             )

    assert query.lock == "FOR SHARE NOWAIT"
  end
end
