defmodule EctoForge.Utls.ExecuteExtension do
  def extensions_get_before_exucute(_module, [], _mode, query, attrs) do
    {query, attrs}
  end

  def extensions_get_before_exucute(module, [h], mode, query, attrs) do
    {query, attrs} = h.before_query_add_extension_to_get(module, mode, query, attrs)
    extensions_get_before_exucute(module, [], mode, query, attrs)
  end

  def extensions_get_before_exucute(module, [h | t], mode, query, attrs) do
    {query, attrs} = h.before_query_add_extension_to_get(module, mode, query, attrs)
    extensions_get_before_exucute(module, t, mode, query, attrs)
  end

  def extensions_get_after_exucute(_module, [], _mode, result, attrs) do
    {result, attrs}
  end

  def extensions_get_after_exucute(module, [h], mode, result, attrs) do
    {result, attrs} = h.after_query_add_extension_to_get(module, mode, result, attrs)
    extensions_get_after_exucute(module, [], mode, result, attrs)
  end

  def extensions_get_after_exucute(module, [h | t], mode, result, attrs) do
    {result, attrs} = h.after_query_add_extension_to_get(module, mode, result, attrs)
    extensions_get_after_exucute(module, t, mode, result, attrs)
  end
end
