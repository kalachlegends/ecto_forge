defmodule EctoForge.Extension.Get.Aggregate do
  @moduledoc """
  ## Use aggregate with your model
  When you using this module your functions find get_all returns 0
  ### Usage

  ```elixir
  use EctoForge.CreateInstance,
    extensions_get: [
      EctoForge.Extension.Get.Aggregate,
    ],
    repo: MyApp.Repo

  ### Using with model functions get get_all find_all find

  ```elixir
  iex -> MyApp.Model.get_all!(%{filter: %{status: "active"}, aggregate: %{field: :id, aggregate: :count, opts: []}})
  0
  ```
   ## Recomidation
  Use at the very end after used extensions because this extension instantly stops the others
  ### Attrs
  """
  # import Ecto.Query
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, nil) do
    {query, %{}}
  end

  def before_query_add_extension_to_get(_module, _mode, repo, _l_ex, query, attrs) do
    {aggregate_attrs, _} = Access.pop(attrs, :aggregate)

    if is_map(aggregate_attrs) or is_list(aggregate_attrs) do
      {aggregate, _} = Access.pop(aggregate_attrs, :aggregate)
      {field, _} = Access.pop(aggregate_attrs, :field)
      {opts, _} = Access.pop(aggregate_attrs, :opts)
      {:result, repo.aggregate(query, aggregate || :count, field, opts || []), query, attrs}
    else
      {query, attrs}
    end
  end
end
