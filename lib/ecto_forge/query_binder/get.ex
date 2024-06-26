defmodule EctoForge.Helpers.QueryBinderGet do
  import Ecto.Query, only: [from: 2]
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
        as_var = @module_model.__schema__(:source)
        query = query_other || from(i in @module_model, as: ^as_var)

        result =
          case ExecuteExtension.extensions_get_before_exucute(
                 @module_model,
                 @extensions_get,
                 mode,
                 @repo,
                 [],
                 query,
                 opts
               ) do
            {new_query, attrs} ->
              result = apply(@repo, mode, [new_query])

              {_prev_query, result, _attrs} =
                ExecuteExtension.extensions_get_after_exucute(
                  @module_model,
                  @extensions_get,
                  mode,
                  @repo,
                  [],
                  new_query,
                  result,
                  opts
                )

              result

            {:result, result, prev_query, _attrs} ->
              {prev_query, result, attrs} =
                ExecuteExtension.extensions_get_after_exucute(
                  @module_model,
                  @extensions_get,
                  @repo,
                  [],
                  prev_query,
                  mode,
                  result,
                  opts
                )

              result
          end

        result
      end
    end
  end
end
