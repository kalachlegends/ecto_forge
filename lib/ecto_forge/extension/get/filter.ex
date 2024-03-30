defmodule EctoForge.Extension.Get.Filter do
  @moduledoc """
  # Implements library https://hexdocs.pm/filtery/readme.html

  ```elixir
  use EctoForge.CreateInstance,
  extensions_get: [
    EctoForge.Extension.Get.Filter,
    ],
    repo: MyApp.Repo
    ```

    ## When you coonnect
    You can use Api https://hexdocs.pm/filtery/readme.html
    ### Example

    ```elixir
     {:ok, []} = MyApp.Model.get_all(filter: %{id: 1})
    ```

      
    ```elixir
     {:ok, []} = MyApp.Model.get_all(filter: %{email: nil}, filter_opts: [skip_nil: true]) # skipped
    ```
  """
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, nil) do
    {query, %{}}
  end

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, attrs) do
    {filter_attrs, _} = Access.pop(attrs, :filter)
    {filter_opts, _} = Access.pop(attrs, :filter_opts)

    if is_list(filter_attrs) or is_map(filter_attrs) do
      {Filtery.apply(query, filter_attrs, filter_opts || []), attrs}
    else
      {query, attrs}
    end
  end
end
