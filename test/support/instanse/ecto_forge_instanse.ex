defmodule Support.EctoForgeInstanceTest do
  use EctoForge.CreateInstance,
    extensions_get: [
      EctoForge.Extension.Get.Preload,
      EctoForge.Extension.Get.Filter
    ],
    repo: EctoForge.Repo
end
