defmodule EctoForge.CreateExtension.Get do
  @moduledoc """

  ## You can use callback functions for processing. After the query and before the query to filter the data.
  You can use callback functions for processing. After the query and before the query to filter the data.
  module MyApp.UserModel -> your own module
  mode -> :all or :one
  query -> handled query
  repo -> MyApp.Repo
  attrs -> attributes that fall
  ```elixir
   def before_query_add_extension_to_get(_module, _mode, _repo, query, attrs) do
  # module MyApp.UserModel

  {query, attrs} # must return query and modified attributes
  end

  def after_query_add_extension_to_get(module, mode, repo, prev_query, result, attrs) do
  # module MyApp.UserModel

  {result, attrs} # must return result and modified attributes
  end

  ```
  ### How to create your extension
  #### Create extenstion is using callbacks before_query_add_extension_to_get(_module, _mode, _repo, query, attrs), after_query_add_extension_to_get(module, mode, repo, prev_query, result, attrs)

  Connect `EctoForge.CreateExtension.Get`
  ```elixir
    defmodule MyApp.Extension.Get.WhereIsMyUserIdOne do
        use EctoForge.CreateExtension.Get
    end
  ```

  #### and After that use your callbacks

  ```elixir
    defmodule MyApp.Extension.Get.WhereIsMyUserIdOne do
        use EctoForge.CreateExtension.Get

        def before_query_add_extension_to_get(_module, _mode, _repo, query, attrs) do
          new_query = where([u], u.id == 1)
          {query, attrs}
        end

    end
  ```


  #### Example
  ```elixir
  defmodule EctoForge.Extension.Get.Preload do
  @moduledoc \"\"\"
  ## Use preload with your model
  ### Example
  MyApp.UserModel.find(preload: [:user])
  \"\"\"
  alias EctoForge.Helpers.RepoBase.Utls
  import Ecto.Query
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, _repo, query, attrs) do
    preload_attrs = Utls.MapUtls.opts_to_map(attrs)
    attrs = Keyword.delete(attrs, :preload)

    if is_list(preload_attrs) do
      {preload(query, ^preload_attrs), attrs}
    else
      {query, attrs}
    end
  end
  end
  ```
  """
  @callback before_query_add_extension_to_get(
              module :: atom(),
              mode :: atom(),
              repo :: Ecto.Repo.t(),
              query :: Ecto.Query.t(),
              attrs :: map() | keyword()
            ) :: tuple()

  @callback after_query_add_extension_to_get(
              module :: atom(),
              mode :: atom(),
              prev_query :: Ecto.Query.t(),
              repo :: Ecto.Repo.t(),
              result :: any(),
              attrs :: map() | keyword()
            ) :: tuple()
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour EctoForge.CreateExtension.Get

      @doc """
      Before with your `query` Handle your functions `find_all` `get_all` `get!` `get` `find` before

      return {query, attrs} # required
      """
      def before_query_add_extension_to_get(module, mode, repo, query, attrs) do
        {query, attrs}
      end

      @doc """
      After with `result` Handle your functions `find_all` `get_all` `get!` `get` `find` before
      return {query, attrs} # required
      """
      def after_query_add_extension_to_get(module, mode, repo, prev_query, result, attrs) do
        {result, attrs}
      end

      defoverridable before_query_add_extension_to_get: 5
      defoverridable after_query_add_extension_to_get: 6
    end
  end
end
