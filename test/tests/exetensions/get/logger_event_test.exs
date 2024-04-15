defmodule Tests.Exetensions.Get.LoggerEventTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  use EctoForge.RepoCase
  alias EctoForgeTest.PostModelWithLogger
  @tag run: true
  setup do
    user = EctoForge.Repo.insert!(%EctoForgeTest.UserModel{name: "arte"})
    [user: user]
  end

  test "Test EctoForge.Extension.Events.Logger.MacroLogger with extensions_events_additional",
       %{user: user} do
    assert capture_log(fn ->
             PostModelWithLogger.create(%{title: "artem", user_id: user.id, description: "asd"})
           end) =~ "create"

    post = PostModelWithLogger.get!(%{filter: %{title: "artem"}})

    assert capture_log(fn ->
             PostModelWithLogger.get!(%{filter: %{title: "artem"}})
           end) =~ "after_get"

    assert capture_log(fn ->
             PostModelWithLogger.get!(%{filter: %{title: "artem"}})
           end) =~ "govno"

    assert capture_log(fn -> PostModelWithLogger.update(post, %{title: "artem11"}) end) =~
             "updated"

    assert capture_log(fn -> PostModelWithLogger.update!(post, %{title: "artem11"}) end) =~
             "updated!"

    assert capture_log(fn -> PostModelWithLogger.delete!(post) end) =~ "deleted!"
  end
end
