defmodule EctoForge.Extension.Get.Pagination do
  @moduledoc """
  # Paginate your Model

  ```elixir
  use EctoForge.CreateInstance,
  extensions_get: [
    EctoForge.Extension.Get.Pagination,
    ],
    repo: MyApp.Repo
    ```

    ## When you coonnect
    You can use Api https://hexdocs.pm/filtery/readme.html
    ### Example

    ```elixir
    {:ok, %{count_data: 30, data: list}} = MyApp.Model.get_all(%{pagination: %{page: 1})
    ```

      ```elixir
    {:ok, %{count_data: 30, data: list}} = MyApp.Model.get_all(%{pagination: %{page: 2, limit: 5})
    ```
  """
  import Ecto.Query
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, nil) do
    {query, %{}}
  end

  def before_query_add_extension_to_get(_module, :all, repo, _l_ex, query, attrs) do
    {pagination_attrs, _} = Access.pop(attrs, :pagination)

    if is_list(pagination_attrs) or is_map(pagination_attrs) do
      limit = get_normalized_integer(pagination_attrs[:limit], 10)
      page = get_normalized_integer(pagination_attrs[:page], 1) - 1
      offeset = page * limit

      paginated_query = query |> limit(^limit) |> offset(^offeset)

      {:result,
       %{data: repo.all(paginated_query), count_data: repo.aggregate(query, :count, :id)}, query,
       attrs}
    else
      {query, attrs}
    end
  end

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, attrs) do
    {query, attrs}
  end

  defp get_normalized_integer(value, default_value) do
    cond do
      is_binary(value) -> value |> String.to_integer()
      is_integer(value) -> value
      true -> default_value
    end
  end
end
