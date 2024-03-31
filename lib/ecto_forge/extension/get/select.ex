defmodule EctoForge.Extension.Get.Select do
  use EctoForge.CreateExtension.Get

  @moduledoc """
  # Use with your `EctoForge.CreateInstance`

  ```elixir
  use EctoForge.CreateInstance,
    extensions_get: [
      EctoForge.Extension.Get.Select,
    ],
    repo: MyApp.Repo
    ```

    ## When you coonnect
    You can select yours fields
    ### Example

    ```elixir
    MyApp.Model.get_all(select: MyApp.Model.fields())
    ```
  """
  import Ecto.Query

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, nil) do
    {query, %{}}
  end

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, attrs) do
    {select_attrs, _} = Access.pop(attrs, :select)

    if is_list(select_attrs) or is_map(select_attrs) do
      {select(query, [w], struct(w, ^select_attrs)), attrs}
    else
      {query, attrs}
    end
  end
end
