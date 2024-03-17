defmodule EctoForge.CreateExtension.Get do
  @moduledoc """

  ## You can use callback functions for processing. After the query and before the query to filter the data.
  You can use callback functions for processing. After the query and before the query to filter the data.
  module MyApp.UserModel -> your own module
  mode -> :all or :one
  query -> handled query
  repo -> MyApp.Repo
  list_exetensions_executed -> Executed list of extensions
  attrs -> attributes that fall
  ```elixir
   def before_query_add_extension_to_get(_module, _mode, _repo, _list_exetensions_executed, query, attrs) do
  # module MyApp.UserModel

  {query, attrs} # must return query and modified attributes
  end

  def after_query_add_extension_to_get(module, mode, repo, _list_exetensions_executed, prev_query, result, attrs) do
  # module MyApp.UserModel

  {prev_query,result, attrs} # must return result and modified attributes
  end
  ```
  ## options :stop, :result
  when you use before_query_add_extension_to_get()
  you can return tuple with {:result, Repo.all(query), attrs}
  This means that your before_query_add_extension_to_get will not go any further I will return a result. This is to bypass the default repo.all function for management

    ```elixir
  def before_query_add_extension_to_get(_module, _mode, repo, _list_exetensions_executed, query, attrs) do
    {:result, repo.all(query), query, attrs} # stoped and don't to execute repo.all or one
  end
  ```

     ```elixir
  def before_query_add_extension_to_get(_module, _mode, _repo,_list_exetensions_executed, query, attrs) do
    {:stop,query, attrs} # stoped and don't to execute another exensions
  end
  ```
     ```elixir
  def  after_query_add_extension_to_get(module, mode, repo, prev_query,_list_exetensions_executed, result, attrs) do
    {:stop,query, attrs} # stoped and don't to execute another exensions
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

        def before_query_add_extension_to_get(_module, _mode, _repo, _list_exetensions_executed, query, attrs) do
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
  MyApp.UserModel.find(preload: [:posts])
  \"\"\"
  alias EctoForge.Helpers.RepoBase.Utls
  import Ecto.Query
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, _repo, _list_exetensions_executed, query, attrs) do
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
              module :: module(),
              mode :: atom() | :all | :one,
              repo :: Ecto.Repo.t(),
              list_exetensions_executed :: list(),
              query :: Ecto.Query.t(),
              attrs :: map() | keyword()
            ) ::
              tuple()
              | {Ecto.Query.t(), map() | keyword()}
              | {:stop, Ecto.Query.t(), map() | keyword()}
              | {:result, any(), Ecto.Query.t(), map() | keyword()}

  @callback after_query_add_extension_to_get(
              module :: module(),
              mode :: atom() | :all | :one,
              repo :: Ecto.Repo.t(),
              list_exetensions_executed :: list(),
              prev_query :: Ecto.Query.t(),
              result :: any(),
              attrs :: map() | keyword()
            ) ::
              tuple()
              | {Ecto.Query.t(), any(), map() | keyword()}
              | {:stop, Ecto.Query.t(), any(), map() | keyword()}

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour EctoForge.CreateExtension.Get

      @doc """
      Before with your `query` Handle your functions `find_all` `get_all` `get!` `get` `find` before

      return {query, attrs}  # required to return

      You can use {:stop, query, attrs} -> Don't execute another extensions before
      You can use {:reusult, result, attrs} -> Don't execute repo extensions before
      """
      def before_query_add_extension_to_get(
            module,
            mode,
            repo,
            list_exetensions_executed,
            query,
            attrs
          ) do
        {query, attrs}
      end

      @doc """
      After with `result` Handle your functions `find_all` `get_all` `get!` `get` `find` before
      You can use {:stop, query, attrs} -> Don't execute another extensions before
      """
      def after_query_add_extension_to_get(
            module,
            mode,
            repo,
            list_exetensions_executed,
            prev_query,
            result,
            attrs
          ) do
        {prev_query, result, attrs}
      end

      defoverridable before_query_add_extension_to_get: 6
      defoverridable after_query_add_extension_to_get: 7
    end
  end
end
