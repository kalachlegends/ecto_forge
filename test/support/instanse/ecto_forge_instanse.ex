defmodule Support.EctoForgeInstanceTest do
  use EctoForge.CreateInstance,
    extensions_get: [
      EctoForge.Extension.Get.Preload,
      EctoForge.Extension.Get.Aggregate,
      EctoForge.Extension.Get.Filter,
      EctoForge.Extension.Get.Pagination
    ],
    repo: EctoForge.Repo
end
