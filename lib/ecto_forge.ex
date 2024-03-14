defmodule EctoForge do
  use EctoForge.CreateInstance,
    extensions_get: [
      EctoForge.Extension.Get.Preload,
      EctoForge.Extension.Get.Filter,
      EctoForge.Extension.Get.Pagination
    ],
    extensions_api: [EctoForge.Extension.Api.Create],
    repo: EctoForge.Repo
end
