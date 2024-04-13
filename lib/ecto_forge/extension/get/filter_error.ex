defmodule EctoForge.Extension.Get.FilterError do
  use EctoForge.CreateExtension.Get

  @moduledoc """
  raise if you didn't pass on %{filter: %{}} in `find_all` `find` `get_all` `get!` `get_all!`
  """
  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, nil) do
    {query, %{}}
  end

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, attrs) do
    {filter_attrs, _} = Access.pop(attrs, :filter)

    if is_list(filter_attrs) or is_map(filter_attrs) do
      {query, attrs}
    else
      raise(EctoForge.Expections.FilterErrorIsRequired)
      {query, attrs}
    end
  end
end
