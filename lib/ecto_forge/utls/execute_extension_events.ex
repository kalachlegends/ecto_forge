defmodule EctoForge.Utls.ExecuteExtensionEvents do
  def exucute_before_created!(result, extensions) when is_list(extensions) do
    Enum.reduce(extensions, result, fn ext, acc -> ext.on_created!(acc) end)
  end

  def exucute_after_get(result, extensions) when is_list(extensions) do
    Enum.reduce(extensions, result, fn ext, acc -> ext.after_get(acc) end)
  end

  def exucute_after_updated(result, extensions) when is_list(extensions) do
    Enum.reduce(extensions, result, fn ext, acc -> ext.after_updated(acc) end)
  end

  def exucute_after_deleted(result, extensions) when is_list(extensions) do
    Enum.reduce(extensions, result, fn ext, acc -> ext.after_deleted(acc) end)
  end

  def exucute_after_created(result, extensions) when is_list(extensions) do
    Enum.reduce(extensions, result, fn ext, acc -> ext.after_created(acc) end)
  end

  def exucute_after_updated!(result, extensions) when is_list(extensions) do
    Enum.reduce(extensions, result, fn ext, acc -> ext.after_updated!(acc) end)
  end

  def exucute_after_deleted!(result, extensions) when is_list(extensions) do
    Enum.reduce(extensions, result, fn ext, acc -> ext.after_deleted!(acc) end)
  end

  def exucute_after_created!(result, extensions) when is_list(extensions) do
    Enum.reduce(extensions, result, fn ext, acc -> ext.after_created!(acc) end)
  end

  @spec exucute_before_updated(any(), maybe_improper_list()) :: any()
  def exucute_before_updated(result, extensions) when is_list(extensions) do
    Enum.reduce(extensions, result, fn ext, acc -> ext.on_updated(acc) end)
  end

  def exucute_before_deleted(result, extensions) when is_list(extensions) do
    Enum.reduce(extensions, result, fn ext, acc -> ext.before_deleted(acc) end)
  end

  def exucute_before_created(result, extensions) when is_list(extensions) do
    Enum.reduce(extensions, result, fn ext, acc -> ext.before_created(acc) end)
  end

  def exucute_before_updated!(result, extensions) when is_list(extensions) do
    Enum.reduce(extensions, result, fn ext, acc -> ext.on_updated!(acc) end)
  end

  def exucute_before_deleted!(result, extensions) when is_list(extensions) do
    Enum.reduce(extensions, result, fn ext, acc -> ext.before_deleted!(acc) end)
  end
end
