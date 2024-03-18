defmodule EctoForge.Extension.Get.OnlyQuery do
  @moduledoc """
  # Use with your `EctoForge.CreateInstance`

  ```elixir
  use EctoForge.CreateInstance,
    extensions_get: [
      EctoForge.Extension.Get.OnlyQuery,
    ],
    repo: MyApp.Repo
    ```

    ## When you coonnect
    You can get only query with your find_all get_all find
    ### Example

    ```elixir
     {:ok, %Ecto.Query{}} = MyApp.Model.find_all(only_query: true)
    ```

     ## Recomidation
  Use at the very end after used extensions because this extension instantly stops the others
  """

  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, nil) do
    {query, %{}}
  end

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, attrs) do
    {boolean_only_query, _} = Access.pop(attrs, :only_query)

    if boolean_only_query == true do
      {:result, query, query, attrs}
    else
      {query, attrs}
    end
  end
end
