defmodule EctoForge.Helpers.QueryBinderGet do
  import Ecto.Query
  # alias EctoForge.Helpers.RepoBase.Utls.MapUtls
  alias EctoForge.Utls.ExecuteExtension

  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @repo opts[:repo]
      @on_get opts[:on_get]
      @module_model opts[:module_model]
      @extensions_get opts[:extensions_get] || []

      def query_bindings(opts \\ %{}, mode \\ :one, query_other \\ false) do
        as_var = @module_model.__schema__(:source) |> normalize_atom
        query = query_other || from(i in @module_model, as: ^as_var)

        {new_query, attrs} =
          ExecuteExtension.extensions_get_before_exucute(
            @module_model,
            @extensions_get,
            mode,
            query,
            opts
          )

        result = apply(@repo, mode, [query])

        {result, attrs} =
          ExecuteExtension.extensions_get_after_exucute(
            @module_model,
            @extensions_get,
            mode,
            result,
            opts
          )

        result
      end

      defp query_function(query, opts \\ %{}) do
        query_function = opts[:query_function]

        if is_function(query_function) do
          query_function.(query)
        else
          query
        end
      end

      defp normalize_atom(atom) when is_atom(atom), do: atom
      defp normalize_atom(atom) when is_binary(atom), do: atom |> String.to_atom()

      # end
    end
  end
end
