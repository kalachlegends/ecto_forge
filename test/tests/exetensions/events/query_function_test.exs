defmodule Tests.Exetensions.QueryFunctionTest do
  use ExUnit.Case

  use EctoForge.RepoCase
  alias EctoForgeTest.UserModel

  test "Test  EctoForge.Extension.Get.QueryFunctionTest" do
    assert {%Ecto.Query{preloads: [:posts]}, %{}} =
             EctoForge.Extension.Get.QueryFunction.before_query_add_extension_to_get(
               UserModel,
               :one,
               EctoForge.Repo,
               [],
               from(user in UserModel, select: user),
               %{query_function: fn query -> query |> Ecto.Query.preload([:posts]) end}
             )
  end
end
