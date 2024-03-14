defmodule Support.EctoForgeInstanceTestEvents do
  use EctoForge.CreateInstance,
    extensions_events: [Test.Event.ExtensionDeleteId],
    extensions_get: [
      EctoForge.Extension.Get.Preload,
      EctoForge.Extension.Get.Filter,
      EctoForge.Extension.Get.Pagination
    ],
    repo: EctoForge.Repo
end
