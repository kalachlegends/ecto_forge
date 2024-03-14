defmodule EctoForge.Extension.Get.Filter do
  @moduledoc """
  # Implements library https://hexdocs.pm/filtery/readme.html


  ```elixir
  use EctoForge.CreateInstance,
    extensions_get: [
      EctoForge.Extension.Get.Preload,
    ],
    repo: MyApp.Repo
  ```
  """
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, query, nil) do
    {query, %{}}
  end

  def before_query_add_extension_to_get(_module, _mode, query, attrs) do
    {Filtery.apply(query, attrs), attrs}
  end
end
