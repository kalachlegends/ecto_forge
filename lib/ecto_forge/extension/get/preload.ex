defmodule EctoForge.Extension.Get.Preload do
  @moduledoc """
  ## Use preload with your model
  ### Example
  ```
  MyApp.UserModel.find(preload: [:user])
  ```
  """
  alias EctoForge.Helpers.RepoBase.Utls
  import Ecto.Query
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, query, attrs) do
    preload_attrs = Utls.MapUtls.opts_to_map(attrs)
    attrs = Keyword.delete(attrs, :preload)

    if is_list(preload_attrs) do
      {preload(query, ^preload_attrs), attrs}
    else
      {query, attrs}
    end
  end
end
