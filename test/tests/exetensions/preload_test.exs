defmodule EctoForgeTest.Extensions.Preload do
  use ExUnit.Case

  use EctoForge.RepoCase
  alias EctoForgeTest.UserModel

  test "Test  EctoForge.Extension.Get.Preload" do
    assert {%Ecto.Query{preloads: [:posts]}, %{}} =
             EctoForge.Extension.Get.Preload.before_query_add_extension_to_get(
               UserModel,
               :one,
               EctoForge.Repo,
               [],
               from(user in UserModel, select: user),
               %{preload: [:posts]}
             )

    assert {%Ecto.Query{preloads: []}, %{}} =
             EctoForge.Extension.Get.Preload.before_query_add_extension_to_get(
               UserModel,
               EctoForge.Repo,
               [],
               :one,
               from(user in UserModel, select: user),
               nil
             )
  end
end
