defmodule Support.EctoForgeInstanceTest do
  use EctoForge.CreateInstance,
    extensions_get: [
      EctoForge.Extension.Get.Preload,
      EctoForge.Extension.Get.Aggregate,
      EctoForge.Extension.Get.Filter,
      EctoForge.Extension.Get.Pagination,
      EctoForge.Extension.Get.Select
    ],
    repo: EctoForge.Repo
end
