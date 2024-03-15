defmodule EctoForge.Helpers.QueryBinderGet do
  import Ecto.Query
  # alias EctoForge.Helpers.RepoBase.Utls.MapUtls
  alias EctoForge.Utls.ExecuteExtension

  @moduledoc """
  The helper module is used to perform an extension for the `find_all` `get_all` `get!()` `get!` functions.
  You can use and create your binder

  ```elixir
  use EctoForge.Helpers.QueryBinderGet module_model: __MODULE__, extensions_get: [], repo: MyApp.Repo
  ```
  """
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
            @repo,
            mode,
            query,
            opts
          )

        result = apply(@repo, mode, [new_query])

        {result, attrs} =
          ExecuteExtension.extensions_get_after_exucute(
            @module_model,
            @extensions_get,
            @repo,
            mode,
            result,
            opts
          )

        result
      end

      defp normalize_atom(atom) when is_atom(atom), do: atom
      defp normalize_atom(atom) when is_binary(atom), do: atom |> String.to_atom()

      # end
    end
  end
end
