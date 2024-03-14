defmodule EctoForge.Helpers.RepoBase.Utls.MapUtls do
  @spec keys_with_path(map, any) :: list
  def keys_with_path(map, prefix \\ []) when is_map(map) do
    Enum.flat_map(map, fn {key, value} ->
      full_key = prefix ++ [key]

      if is_map(value) do
        keys_with_path(value, full_key)
      else
        [full_key]
      end
    end)
  end

  @spec opts_to_map(maybe_improper_list() | map()) :: any()
  def opts_to_map(opts) when is_map(opts),
    do:
      opts
      |> Map.new(fn {k, v} ->
        if is_binary(k) do
          {String.to_atom(k), v}
        else
          {k, v}
        end
      end)

  def opts_to_map(opts) when is_list(opts) do
    Enum.reduce(opts, %{}, fn {key, value}, acc -> Map.put(acc, key, value) end)
  end
end
