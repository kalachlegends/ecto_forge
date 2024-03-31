defmodule EctoForge.Extension.Get.QueryFunction do
  @moduledoc """
  ### Usage

  ```elixir
  use EctoForge.CreateInstance,
    extensions_get: [
      EctoForge.Extension.Get.QueryFunction,
    ],
    repo: MyApp.Repo
  ```

  ### Example

  ```elixir
  MyApp.Model.get_all(query_function: fn query -> from(sm_query in query) end)
  ```
  """
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, nil) do
    {query, %{}}
  end

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, attrs) do
    {query_function, _} = Access.pop(attrs, :query_function)

    if is_function(query_function) do
      {query_function.(query), attrs}
    else
      {query, attrs}
    end
  end
end
