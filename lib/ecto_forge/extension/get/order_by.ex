defmodule EctoForge.Extension.Get.OrderBy do
  @moduledoc """
  # Use with your `EctoForge.CreateInstance`

  ```elixir
  use EctoForge.CreateInstance,
    extensions_get: [
      EctoForge.Extension.Get.OrderBy,
    ],
    repo: MyApp.Repo
    ```

    ## When you coonnect
    You can use Api https://hexdocs.pm/ecto/Ecto.Query.html#order_by/3
    ### Example

    ```elixir
     {:ok, []} = MyApp.Model.get_all(order_by: [asc: :name, desc_nulls_first: :population])
    ```
  """
  import Ecto.Query
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, nil) do
    {query, %{}}
  end

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, attrs) do
    {order_by_attrs, _} = Access.pop(attrs, :order_by)

    if is_list(order_by_attrs) or is_map(order_by_attrs) do
      {order_by(query, ^order_by_attrs), attrs}
    else
      {query, attrs}
    end
  end
end
