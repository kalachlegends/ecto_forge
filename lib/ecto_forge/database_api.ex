defmodule EctoForge.DatabaseApi do
  alias EctoForge.Utls.ExecuteExtensionEvents

  @moduledoc """
  ## Implements base functions for database

  ```elixir
  use(
            EctoForge.DatabaseApi,
            [
              repo: MyApp.Repo, # required param
              extensions_get: [], # default list
              extensions_events: [] # default list
            ]
          )
  ```
  functions find_all, works only with extension `EctoForge.Extension.Get.Preload`, `EctoForge.Extension.Get.Filter` or you can write yours own

  This module creates an instance of the database all functions function. It can be used through the use of Parameter

  - create(map) # takes changeset and does repo.insert()
  - create(map, :function_for_changeset),
  - create!(map, :function_for_changeset), # takes function_for_changeset from the module and does repo.insert!()
  - create!(map, :function_for_changeset), # takes the changeset and does a repo.insert!()
  - find_all(map or keyword) # returns result_list or nil
  - find(map or keyword) # returns result or nil
  - get(map or keyword) # returns {:ok, result_one} or {:error, result_one}
  - get!(map or keyword) # returns result or return throw
  - get_all(map or keyword) # returns {:ok, list} or {:error, list}
  - get_all!(map or keyword) # result  items or throw(no results)
  - update_by_opts(get_params, update) # result {:ok, item} or {:error, result}
  - update(item, opts_update)  # result {:ok, item} or {:error, result}
  - update!(item, update_opts) # return item or throw
  - update(item) # return {:ok, item} or {:error, result}
  - update_with_another_changeset!(%@module_model{} = item, opts, function_atom) # return item or throw
  - update_with_another_changeset(%@module_model{} = item, opts, function_atom)  # return {:ok, item} or {:error, result}
  - delete(%@module_model{} or opts_for_get) # result {:ok, _} or {:error, _}
  - delete!(%@module_model{} or opts_for_get) # result {:ok, _} or {:error, _}
  - update_or_create!(get_attrs, or_insert_update_attrs, opts )
  - update_or_create(get_attrs, or_insert_update_attrs, opts )
  """
  @callback create!(
              create_attrs ::
                map() | keyword() | maybe_improper_list(byte() | binary() | iolist(), binary()),
              function_changest_from_module :: atom()
            ) :: struct()
  @callback create!(
              create_attrs ::
                map() | keyword() | maybe_improper_list(byte() | binary() | iolist(), binary())
            ) ::
              struct()
  @callback create(
              create_attrs ::
                map() | keyword() | maybe_improper_list(byte() | binary() | iolist(), binary())
            ) ::
              {:ok, struct()} | {:error, Ecto.Changeset.t()}
  @callback create(
              create_attrs :: maybe_improper_list(byte() | binary() | iolist(), binary()),
              function_changest_from_module :: atom()
            ) ::
              {:ok, struct()} | {:error, Ecto.Changeset.t()}
  @callback find(get_attrs :: map() | keyword()) :: nil | struct()
  @callback find_all(get_attrs :: map() | keyword()) :: [] | list(struct())
  @callback get_all(get_attrs :: map() | keyword()) :: {:ok, list(struct())} | {:error, []}
  @callback get(get_attrs :: map() | keyword()) :: {:ok, struct()} | {:error, any()}
  @callback get!(get_attrs :: map() | keyword()) :: struct()
  @callback get_all!(get_attrs :: map() | keyword()) :: list(struct())
  # @callback get_all!(get_attrs :: map() | keyword()) :: list(struct())
  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @module_model opts[:module_model] || __MODULE__
      @behaviour EctoForge.DatabaseApi
      @doc """
      ## Implements base functions for database


      functions find_all, works only with extension `EctoForge.Extension.Get.Preload`, `EctoForge.Extension.Get.Filter` or you can write yours own

      This module creates an instance of the database all functions function. It can be used through the use of Parameter

      - create(map) # takes changeset and does repo.insert()
      - create(map, :function_for_changeset),
      - create!(map, :function_for_changeset), # takes function_for_changeset from the module and does repo.insert!()
      - create!(map, :function_for_changeset), # takes the changeset and does a repo.insert!()
      - find_all(map or keyword) # returns result_list or nil
      - find(map or keyword) # returns result or nil
      - get(map or keyword) # returns {:ok, result_one} or {:error, result_one}
      - get!(map or keyword) # returns result or return throw
      - get_all(map or keyword) # returns {:ok, list} or {:error, list}
      - get_all!(map or keyword) # result  items or throw(no results)
      - update_by_opts(get_params, update) # result {:ok, item} or {:error, result}
      - update(item, opts_update)  # result {:ok, item} or {:error, result}
      - update!(item, update_opts) # return item or throw
      - update(item) # return {:ok, item} or {:error, result}
      - update_with_another_changeset!(%@module_model{} = item, opts, function_atom) # return item or throw
      - update_with_another_changeset(%@module_model{} = item, opts, function_atom)  # return {:ok, item} or {:error, result}
      - delete(%@module_model{} or opts_for_get) # result {:ok, _} or {:error, _}
      - delete!(%@module_model{} or opts_for_get!) # result {:ok, _} or {:error, _}
        - update_or_create!(get_attrs, or_insert_update_attrs, opts )
      - update_or_create(get_attrs, or_insert_update_attrs, opts )

      """

      @repo opts[:repo]

      @extensions_events opts[:extensions_events] || []

      @ignore_fields opts[:ignore_fields] || []
      @extensions_get opts[:extensions_get] || []
      @not_found_message opts[:error_message] || :not_found
      if length(@extensions_get) == 0 do
        :logger.warning("extensions_get give [], expect [Some.Extesnisons]")
      end

      use EctoForge.Helpers.QueryBinderGet,
        repo: @repo,
        extensions_get: opts[:extensions_get],
        module_model: @module_model

      @doc """
      ## Creates and does structure insert by default pulls the changeset function from `#{@module_model}`.

      Returns `{{:ok, item}` or `{:error, error_changeset}`.
      ## Example
       ```elixir
      #{@module_model}.create(%{name: "artem"})

      ```
      """
      def create(map) do
        map = ExecuteExtensionEvents.exucute_before_created(map, @extensions_events)

        @module_model.changeset(%@module_model{}, map)
        |> @repo.insert()
        |> ExecuteExtensionEvents.exucute_after_created(@extensions_events)
      end

      @doc """
      ## Creates and makes insert structures, together with the changeset function

      Returns `{:ok, item}` or `{:error, error_changeset}`.
      ## Example
      ```elixir
      #{@module_model}.create(%{name: "artem"}, :changeset_register)

      ```

      """
      def create(map, function) do
        map = ExecuteExtensionEvents.exucute_before_created(map, @extensions_events)

        apply(@module_model, function, [@module_model, map])
        |> @repo.insert()
        |> ExecuteExtensionEvents.exucute_after_created(@extensions_events)
      end

      @doc """
      ## Creates and does structure insert by default pulls the changeset function from `#{@module_model}`.

      Returns `{:ok, item}` or `{:error, error_changeset}`.
      ## Example
      ```elixir
      #{@module_model}.create(%{name: "artem"})

      ```
      """
      def create!(map) do
        map = ExecuteExtensionEvents.exucute_before_created!(map, @extensions_events)

        @module_model.changeset(%@module_model{}, map)
        |> @repo.insert!()
        |> ExecuteExtensionEvents.exucute_after_created!(@extensions_events)
      end

      @doc """
      ## Creates and makes insert structures, together with the changeset function

      Returns `{:ok, item}` or `{:error, error_changeset}`.
      ## Example
      ```elixir
      #{@module_model}.create(%{name: "artem"}, :changeset_register)

      ```

      """
      def create!(map, function) do
        map = ExecuteExtensionEvents.exucute_before_created!(map, @extensions_events)

        res =
          apply(@module_model, function, [map])
          |> @repo.insert!()
          |> ExecuteExtensionEvents.exucute_after_created!(@extensions_events)
      end

      @doc """
       # Returns all fields in the scheme


      ## Example
      ```elixir
      iex> #{@module_model}.fields()
      [:id, :name]

      ```

      ## You can filter out values that are not needed
      ```elixir
      iex> #{@module_model}.fields([:id])
      [:name]
      ```
      """
      def fields(filtered \\ []) when is_list(filtered) do
        schema = @module_model.__schema__(:fields)

        if filtered != [] do
          schema
          |> Enum.filter(fn x ->
            !(x in filtered)
          end)
        else
          schema
        end
      end

      @doc """
      ##   Returns a structure by its id or by matching the value of the structure's fields

      ```elixir
      #{@module_model}.find(id: id) # nil or item
      ```
      """
      def find(opts) when is_list(opts) or is_map(opts) do
        try do
          query_bindings(opts, :one)
        rescue
          Ecto.Query.CastError -> nil
        end
        |> get_helper_after
      end

      @doc """
      ## Returns a structure by its id or by matching the value of the structure's fields

      ## Example
      ```elixir
      iex -> #{@module_model}.get(
        type_private: :public,
      )
      iex -> {:ok, #{@module_model}} # or {:error, #{@module_model}}
      ```

      """
      def get(item_id_or_opts) do
        case find(item_id_or_opts) do
          %@module_model{} = item -> {:ok, item}
          nil -> {:error, @not_found_message}
        end
      end

      @doc """
      ## Returns a structure by its id or by matching the value of the structure's fields

      ## Example
      ```elixir
      iex -> #{@module_model}.get!(
        type_private: :public,
      )
      iex -> #{@module_model} # or throw()
      ```

      """
      def get!(item_id_or_opts) do
        case find(item_id_or_opts) do
          %@module_model{} = item -> item
          nil -> throw(%Ecto.NoResultsError{message: "#{inspect(%@module_model{})} not found"})
        end
      end

      @doc """
      ## Gets or adds an entry if not found
      ## Example
      ```elixir
      #{@module_model}.get_or_insert(%{user_id: ""}, %{login: "12", password: "1234"})
      ```

      """
      def get_or_insert(attrs_get, attrs_create) do
        case get(attrs_get) do
          {:ok, user} -> {:ok, user}
          {:error, _} -> create(attrs_create)
        end
      end

      @doc """
      ## reurn true false if model exists
      ## Example
      ```elixir
      #{@module_model}.exists(id: 1)
      ```

      """
      def exists?(opts) when is_list(opts) or is_map(opts) do
        get!(opts)
        |> @repo.exists?()
      end

      @doc """
      ## Returns a list of all available structures or matching structure field values
      ## The most important thing to understand
      In get_all you can pass map or keyword list everything will fall where
      #{@module_model}.get_all(%{status: 1}))
      will equate to `#{@module_model}|> where(%{status: 1)`

      #{@module_model}.get_all(%{preload: [:posts]})
      will equate to `#{@module_model}|> preload( [:user])`
      ## Example
      ```elixir
      ##{@module_model}.get_all(
        type_private: :public,
      )
      ```




      """
      def find_all(opts \\ nil) do
        try do
          query_bindings(opts, :all)
        rescue
          Ecto.Query.CastError -> []
        end
        |> get_helper_after
      end

      @doc """
      ## Returns a list of all available structures or matching structure field values
      ## example
      ```elixir
      iex-> #{@module_model}.get_all(
      type_private: :public,
      )
      iex-> {:ok, [#{@module_model}]}  or {:error, #{@not_found_message}}
      ```
      """

      def get_all(opts \\ nil) do
        case find_all(opts) do
          [] -> {:error, @not_found_message}
          items -> {:ok, items}
        end
      end

      @doc """
      ## Returns a list of all available structures or matching structure field values
      ## example
      ```elixir
      iex-> #{@module_model}.get_all!(
      type_private: :public,
      )
      iex->  [#{@module_model}]  or throw(no_results)
      ```

      """
      def get_all!(item_id_or_opts \\ nil) do
        case find_all(item_id_or_opts) do
          [] -> throw(%Ecto.NoResultsError{message: "#{inspect(%@module_model{})} not found"})
          items -> items
        end
      end

      @doc """
      ## Update structure with another changeset

      iex -> update_with_another_changeset(#{@module_model}, %{update_attrs: ""}, :function_in_changeset)

      the third argument is the function that is in the module
      """
      def update_with_another_changeset(%@module_model{} = item, opts, function_atom, attrs \\ [])
          when is_atom(function_atom) do
        opts = ExecuteExtensionEvents.exucute_before_updated!(opts, @extensions_events)

        res =
          apply(@module_model, function_atom, [item, opts])
          |> @repo.update(attrs)
          |> ExecuteExtensionEvents.exucute_after_updated!(@extensions_events)
      end

      @doc """
       ## Updating a structure with another changeset throws throw

      iex -> update_with_another_changeset!(#{@module_model}, %{update_attrs: ""}, :function_in_changeset))

      the third argument is the function that is in the module
      """
      def update_with_another_changeset!(
            %@module_model{} = item,
            opts,
            function_atom,
            attrs \\ []
          )
          when is_atom(function_atom) do
        opts = ExecuteExtensionEvents.exucute_before_updated!(opts, @extensions_events)

        res =
          apply(@module_model, function_atom, [item, opts])
          |> @repo.update!(attrs)
          |> ExecuteExtensionEvents.exucute_after_updated!(@extensions_events)
      end

      @doc """
      ## Update item %{}
      ```elixir
      iex ->  update(#{@module_model}, %{update_attrs: ""}, repo.update.attrs)
      ```
      """
      def update(%@module_model{} = item, opts, attrs \\ []) do
        opts = ExecuteExtensionEvents.exucute_before_updated(opts, @extensions_events)

        res =
          item
          |> @module_model.changeset(EctoForge.Helpers.RepoBase.Utls.MapUtls.opts_to_map(opts))
          |> @repo.update(attrs)
          |> ExecuteExtensionEvents.exucute_after_updated(@extensions_events)
      end

      @doc """
          ## Updates item record, %{}, throws exception
      iex -> `update!(#{@module_model}, %{update_attrs: ""}, repo.update
      """
      def update!(%@module_model{} = item, opts, attrs \\ []) do
        opts = ExecuteExtensionEvents.exucute_before_updated!(opts, @extensions_events)

        item
        |> @module_model.changeset(EctoForge.Helpers.RepoBase.Utls.MapUtls.opts_to_map(opts))
        |> @repo.update!(attrs)
        |> ExecuteExtensionEvents.exucute_after_updated!(@extensions_events)
      end

      @doc """
      ## Gets the structure with #{@module_model}.get(get_opts) and updates it

      iex -> update_by_opts(%{id: 1} %{update_attrs: "asd"}, []) third parameter for

      ## Returns
      {:ok, _}
      {:error, _}
      """
      def update_by_opts(get_opts, update_opts, attrs \\ []) do
        with {:ok, item} <- get(get_opts),
             {:ok, item} <- update(item, update_opts, attrs) do
          {:ok, item}
        end
      end

      @doc """
      ## Gets the structure with #{@module_model}.get(get_opts) and updates it

      iex -> update_by_opts(#{@module_model} %{update_attrs: "asd"}, []) third parameter for the
      """
      def update_by_opts!(get_opts, update_opts, attrs \\ []) do
        res =
          get!(get_opts)
          |> update!(update_opts, attrs)
      end

      @doc """
      ## delete by #{@module_model}

      ```elixir
      iex -> delete(#{@module_model})
      iex -> {:ok, _} # or {:error, _}
      ```
      """
      def delete(%@module_model{} = item) do
        item = ExecuteExtensionEvents.exucute_before_deleted(item, @extensions_events)

        try do
          @repo.delete(item)
          |> ExecuteExtensionEvents.exucute_after_deleted(@extensions_events)
        rescue
          err -> {:error, err}
        end
      end

      @doc """
      ## delete by #{@module_model}

      ```elixir
      iex -> delete!(#{@module_model})
      iex ->  ok or throw
      ```
      """
      def delete!(%@module_model{} = item) do
        ExecuteExtensionEvents.exucute_before_deleted!(item, @extensions_events)

        res =
          @repo.delete!(item)
          |> ExecuteExtensionEvents.exucute_after_deleted!(@extensions_events)
      end

      @doc """
      ## get structure and delete it using functions #{@module_model}.get(%{}) |> #{@module_model}.delete
      """
      def delete!(item_id_or_opts) when is_map(item_id_or_opts) or is_binary(item_id_or_opts) do
        get!(item_id_or_opts)
        |> delete!()
      end

      @doc """
      ## get structure and delete it using functions #{@module_model}.get(%{}) |> #{@module_model}.delete

      """
      def delete(item_id_or_opts) do
        with {:ok, item} <- get(item_id_or_opts),
             {:ok, item} <- delete(item) do
          {:ok, item}
        end
      end

      @doc """
      ## do update or create

      ## Example

      ```elixir
      # attrs_updat_or_insert
      #{@module_model}.update_or_create!(%{filter: %{artem: "artem"}, %{artem: "artem"}})
      ```
      """
      def update_or_create!(get_attrs, or_insert_update_attrs, opts \\ []) do
        case find(get_attrs) do
          %@module_model{} = item ->
            update_with_another_changeset!(
              item,
              or_insert_update_attrs,
              opts[:update_changeset] || :changeset
            )

          nil ->
            create!(or_insert_update_attrs, opts[:create_changeset] || :changeset)
        end
      end

      def update_or_create(get_attrs, or_insert_update_attrs, opts \\ []) do
        case find(get_attrs) do
          %@module_model{} = item ->
            update_with_another_changeset(
              item,
              or_insert_update_attrs,
              opts[:update_changeset] || :changeset
            )

          nil ->
            create(or_insert_update_attrs, opts[:create_changeset] || :changeset)
        end
      end

      defp get_helper_after(result) do
        case result do
          {:ok, item} ->
            ExecuteExtensionEvents.exucute_after_get(item, @extensions_events)

          {:error, _} ->
            result

          [] ->
            result

          nil ->
            result

          result ->
            ExecuteExtensionEvents.exucute_after_get(result, @extensions_events)
        end
      end
    end
  end
end
