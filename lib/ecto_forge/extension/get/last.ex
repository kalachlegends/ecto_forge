defmodule EctoForge.Extension.Get.Last do
  @moduledoc """
  # Use last with your `EctoForge.CreateInstance`

  ```elixir
  use EctoForge.CreateInstance,
    extensions_get: [
      EctoForge.Extension.Get.Last,
    ],
    repo: MyApp.Repo
    ```

    ## When you coonnect
    You can use Api https://hexdocs.pm/ecto/Ecto.Query.html#last/2
    ### Example

    ```elixir
     {:ok, []} = MyApp.Model.get_all(last: :inserted_at)
    ```
  """
  import Ecto.Query
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, nil) do
    {query, %{}}
  end

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, attrs) do
    {last_attrs, _} = Access.pop(attrs, :last)

    if is_list(last_attrs) or is_map(last_attrs) or
         (is_atom(last_attrs) and not is_nil(last_attrs)) do
      {last(query, last_attrs), attrs}
    else
      {query, attrs}
    end
  end
end
