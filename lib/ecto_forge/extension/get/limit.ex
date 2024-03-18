defmodule EctoForge.Extension.Get.Limit do
  @moduledoc """
  # Use limit with your `EctoForge.CreateInstance`

  ```elixir
  use EctoForge.CreateInstance,
    extensions_get: [
      EctoForge.Extension.Get.Limit,
    ],
    repo: MyApp.Repo
    ```

    ## When you coonnect
    You can use Api https://hexdocs.pm/ecto/Ecto.Query.html#limit/3
    ### Example

    ```elixir
     {:ok, []} = MyApp.Model.get_all(limit: 10)
    ```
  """
  import Ecto.Query
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, nil) do
    {query, %{}}
  end

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, attrs) do
    {limit_attrs, _} = Access.pop(attrs, :limit)

    if is_integer(limit_attrs) do
      {limit(query, ^limit_attrs), attrs}
    else
      {query, attrs}
    end
  end
end
