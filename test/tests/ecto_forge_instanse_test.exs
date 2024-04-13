defmodule EctoForgeInstanseTest do
  use ExUnit.Case

  use EctoForge.RepoCase
  alias EctoForgeTest.UserModel

  setup do
    user = EctoForge.Repo.insert!(%UserModel{name: "arte"})
    :ok
  end

  test "try do exetension EctoForgeInstanceTest.execute_extension()" do
    assert [%UserModel{name: arte}] =
             Support.EctoForgeInstanceTest.execute_extension(from(user in UserModel), :all, %{
               filter: %{name: "arte"}
             })

    assert [%UserModel{name: arte}] =
             Support.EctoForgeInstanceTest.execute_extension(from(user in UserModel), :all, %{
               filter: %{name: "arte"}
             })
  end
end
