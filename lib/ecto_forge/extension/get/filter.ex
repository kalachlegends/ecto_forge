defmodule EctoForge.Extension.Get.Filter do
  @moduledoc """
  # Implements library https://hexdocs.pm/filtery/readme.html
  """
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, query, attrs) do
    {Filtery.apply(query, attrs), attrs}
  end
end
