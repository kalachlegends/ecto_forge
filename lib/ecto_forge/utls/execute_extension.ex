defmodule EctoForge.Utls.ExecuteExtension do
  def extensions_get_before_exucute(
        _module,
        [],
        _mode,
        _repo,
        _list_exetensions_executed,
        query,
        attrs
      ) do
    {query, attrs}
  end

  def extensions_get_before_exucute(
        module,
        [h],
        mode,
        repo,
        list_exetensions_executed,
        query,
        attrs
      ) do
    case h.before_query_add_extension_to_get(
           module,
           mode,
           repo,
           list_exetensions_executed,
           query,
           attrs
         ) do
      {:result, result, query, attrs} -> {:result, result, query, attrs}
      {:stop, query, attrs} -> {query, attrs}
      {query, attrs} -> {query, attrs}
    end
  end

  def extensions_get_before_exucute(
        module,
        [h | t],
        mode,
        repo,
        list_exetensions_executed,
        query,
        attrs
      ) do
    case h.before_query_add_extension_to_get(
           module,
           mode,
           repo,
           list_exetensions_executed,
           query,
           attrs
         ) do
      {:result, result, query, attrs} ->
        {:result, result, query, attrs}

      {:stop, query, attrs} ->
        {query, attrs}

      {query, attrs} ->
        extensions_get_before_exucute(
          module,
          t,
          mode,
          repo,
          [
            h
            | list_exetensions_executed
          ],
          query,
          attrs
        )
    end
  end

  def extensions_get_after_exucute(
        _module,
        [],
        _mode,
        _repo,
        _list_exetensions_executed,
        prev_query,
        result,
        attrs
      ) do
    {prev_query, result, attrs}
  end

  def extensions_get_after_exucute(
        module,
        [h],
        mode,
        repo,
        list_exetensions_executed,
        prev_query,
        result,
        attrs
      ) do
    case h.after_query_add_extension_to_get(
           module,
           mode,
           repo,
           list_exetensions_executed,
           prev_query,
           result,
           attrs
         ) do
      {prev_query, result, attrs} ->
        {prev_query, result, attrs}

      {:stop, prev_query, result, attrs} ->
        {prev_query, result, attrs}
    end
  end

  def extensions_get_after_exucute(
        module,
        [h | t],
        mode,
        repo,
        list_exetensions_executed,
        prev_query,
        result,
        attrs
      ) do
    case h.after_query_add_extension_to_get(
           module,
           mode,
           repo,
           list_exetensions_executed,
           prev_query,
           result,
           attrs
         ) do
      {:stop, prev_query, result, attrs} ->
        {prev_query, result, attrs}

      {prev_query, result, attrs} ->
        extensions_get_after_exucute(
          module,
          t,
          mode,
          repo,
          [h | list_exetensions_executed],
          prev_query,
          result,
          attrs
        )
    end
  end
end
