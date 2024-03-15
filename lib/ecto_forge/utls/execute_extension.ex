defmodule EctoForge.Utls.ExecuteExtension do
  def extensions_get_before_exucute(_module, [], _mode, _repo, query, attrs) do
    {query, attrs}
  end

  def extensions_get_before_exucute(module, [h], mode, repo, query, attrs) do
    {query, attrs} = h.before_query_add_extension_to_get(module, mode, repo, query, attrs)
    extensions_get_before_exucute(module, [], mode, repo, query, attrs)
  end

  def extensions_get_before_exucute(module, [h | t], mode, repo, query, attrs) do
    {query, attrs} = h.before_query_add_extension_to_get(module, mode, repo, query, attrs)
    extensions_get_before_exucute(module, t, mode, repo, query, attrs)
  end

  def extensions_get_after_exucute(_module, [], _mode, _repo, prev_query, result, attrs) do
    {prev_query, result, attrs}
  end

  def extensions_get_after_exucute(module, [h], mode, repo, prev_query, result, attrs) do
    case h.after_query_add_extension_to_get(module, mode, repo, prev_query, result, attrs) do
      {prev_query, result, attrs} ->
        h.after_query_add_extension_to_get(
          module,
          mode,
          repo,
          prev_query,
          prev_query,
          result,
          attrs
        )

        extensions_get_after_exucute(module, [], mode, repo, prev_query, result, attrs)

      {:stop, prev_query, result, attrs} ->
        h.after_query_add_extension_to_get(
          module,
          mode,
          repo,
          prev_query,
          prev_query,
          result,
          attrs
        )

        extensions_get_after_exucute(module, [], mode, repo, prev_query, result, attrs)
    end
  end

  def extensions_get_after_exucute(module, [h | t], mode, repo, prev_query, result, attrs) do
    case h.after_query_add_extension_to_get(module, mode, repo, prev_query, result, attrs) do
      {:stop, prev_query, result, attrs} ->
        extensions_get_after_exucute(module, [], mode, repo, prev_query, result, attrs)

      {prev_query, result, attrs} ->
        extensions_get_after_exucute(module, t, mode, repo, prev_query, result, attrs)
    end
  end
end
