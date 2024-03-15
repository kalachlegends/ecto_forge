defmodule EctoForgeTest.Extensions do
  use ExUnit.Case

  use EctoForge.RepoCase
  alias EctoForgeTest.UserModel

  test "Test  EctoForge.Extension.Get.Preloa" do
    assert {%Ecto.Query{preloads: [:user]}, %{}} =
             EctoForge.Extension.Get.Preload.before_query_add_extension_to_get(
               UserModel,
               :one,
               EctoForge.Repo,
               from(user in UserModel, select: user),
               %{preload: [:user]}
             )

    assert {%Ecto.Query{preloads: []}, %{}} =
             EctoForge.Extension.Get.Preload.before_query_add_extension_to_get(
               UserModel,
               EctoForge.Repo,
               :one,
               from(user in UserModel, select: user),
               nil
             )
  end

  test "Test  EctoForge.Extension.Get.Filter" do
    assert {query, %{}} =
             EctoForge.Extension.Get.Filter.before_query_add_extension_to_get(
               UserModel,
               EctoForge.Repo,
               :one,
               from(user in UserModel, select: user),
               %{name: "artem"}
             )

    assert {%Ecto.Query{}, %{}} =
             EctoForge.Extension.Get.Filter.before_query_add_extension_to_get(
               UserModel,
               EctoForge.Repo,
               :one,
               from(user in UserModel, select: user),
               nil
             )
  end
end
