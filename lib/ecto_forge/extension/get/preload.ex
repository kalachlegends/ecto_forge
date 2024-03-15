defmodule EctoForge.Extension.Get.Preload do
  @moduledoc """
  ## Use preload with your model
  ### Example
  ```
  MyApp.UserModel.find(preload: [:user])
  ```
  ### Usage

  ```elixir
  use EctoForge.CreateInstance,
    extensions_get: [
      EctoForge.Extension.Get.Preload,
    ],
    repo: MyApp.Repo
  ```
  """
  import Ecto.Query
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, _repo, query, nil) do
    {query, %{}}
  end

  def before_query_add_extension_to_get(_module, _mode, _repo, query, attrs) do
    {preload_attrs, _} = Access.pop(attrs, :preload)

    if is_list(preload_attrs) do
      {preload(query, ^preload_attrs), attrs}
    else
      {query, attrs}
    end
  end
end
