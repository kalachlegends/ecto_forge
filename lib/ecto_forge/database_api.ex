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
              extensions_events: [], # default list
              extensions_events_additional: [], # this don't rewrite  extensions_get when you use EctoForge.Instanse
              extensions_get_additional: [], # this don't rewrite  extensions_get when you use EctoForge.Instanse
            ]
          )
  ```
  ### addinotal
  if you use through use `EctoForge.CreateInstance`

  you can rewrite `extensions_get` `extensions_events`
  with extensions_events_additional



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
  @doc """
  do another changeset in your model with Repo.insert!()
  ### example

  ```elixir
  "@module_model".create(%{name: "artem"}, :another_changeset_in_your_module_model)
  ```
  """
  @callback create!(
              map ::
                map() | keyword(),
              function :: atom()
            ) :: struct()

  @doc """
  do changeset with Repo.insert!()
  ### example

  ```elixir
  "@module_model".create(%{name: "artem"})
  ```
  """
  @callback create!(
              map ::
                map() | keyword()
            ) ::
              struct()

  @doc """
   do changeset with Repo.insert()
  ## example

  ```elixir
  {:ok, _}= "@module_model".create(%{name: "artem"})
  ```
  """
  @callback create(
              create_attrs ::
                map() | keyword()
            ) ::
              {:ok, struct()} | {:error, Ecto.Changeset.t()}

  @doc """
  do another changeset in your model with Repo.insert!()
  ### example

  ```elixir
  "@module_model".create!(%{name: "artem"}, :function_changest_from_module)
  ```
  """
  @callback create(
              create_attrs :: map() | keyword(),
              function_changest_from_module :: atom()
            ) ::
              {:ok, struct()} | {:error, Ecto.Changeset.t()}

  @doc """
  find something in your  "@module_model"  execut your extension and can be filtered or
  ### example

  ```elixir
  nil_or_sturct = "@module_model".find(%{filter: %{name: "some"}})
  ```
  """
  @callback find(get_attrs :: map() | keyword()) :: nil | struct()
  @doc """
  execut your extension and can be filtered or
  ### example

  ```elixir
  nil_or_sturct = "@module_model".find(%{filter: %{name: "some"}})
  ```
  """
  @callback find_all(get_attrs :: map() | keyword()) :: [] | list(struct())
  @doc """
  execut your extension get and can be filtered
  if not found
  ### example

  ```elixir
  {:ok, [@module_model]} = "@module_model".get_all(%{filter: %{name: "some"}})
  ```
  """

  @callback get_all(get_attrs :: map() | keyword()) :: {:ok, list(struct())} | {:error, any()}
  @doc """
  execut your extension get and can be filtered
  if not found
  ### example

  ```elixir
  {:ok, @module_model} = "@module_model".get(%{filter: %{name: "some"}})
  ```
  """
  @callback get(get_attrs :: map() | keyword()) :: {:ok, struct()} | {:error, any()}
  @doc """
  execut your extension get and can be filtered
  if not found do error `Ecto.NoResultsError`
  ### example

  ```elixir
  @module_model = "@module_model".get(%{filter: %{name: "some"}})
  ```
  """
  @callback get!(get_attrs :: map() | keyword()) :: struct()
  @doc """
  execut your extension get and can be filtered
  if not found do error `Ecto.NoResultsError`
  ### example

  ```elixir
  {:ok, [@module_model]} = "@module_model".get_all(%{filter: %{name: "some"}})
  ```
  """
  @callback get_all!(get_attrs :: map() | keyword()) :: list(struct())
  @doc """
  do your changeset with @module_model and Repo.update()
  ### example
  ```elixir
  {:ok, _update} "@module_model".update(%{})
  ```
  """
  @callback update(item :: struct(), opts :: map() | keyword(), attrs :: keyword()) ::
              {:ok, struct()} | {:error, struct()}
  @doc """
  do your changeset with @module_model and Repo.update!()
  ### example
  ```elixir
  @module_model = "@module_model".update!(%{})
  ```
  """
  @callback update!(item :: struct(), opts :: map() | keyword(), attrs :: keyword()) ::
              {:ok, struct()} | {:error, struct()}
  @doc """
  delete your Model by struct do Repo.delete()
  ```elixir
  {:ok, Ecto.Schema.t()} = "@module_model".delete(@module_model)
  ```
  ### you can use filter if you pass on %{filter: %{}}

  ```elixir
   {:ok, Ecto.Schema.t()} = "@module_model".delete(%{filter: %{id: 1}})
  ```
  """
  @callback delete(item :: struct() | map() | keyword()) ::
              {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  @doc """
  delete your Model by struct do Repo.delete!()
  ```elixir
  {:ok, Ecto.Schema.t()} = "@module_model".delete(@module_model)
  ```
  you can use filter if you pass on %{filter: %{}}
  ```elixir
   Ecto.Schema.t() = "@module_model".delete(%{filter: %{id: 1}})
  ```
  """
  @callback delete!(item :: struct() | map() | keyword()) ::
              Ecto.Schema.t()

  @doc """
  do @module_model.get!() if got and  do @module_model.update!()
  ### example

  ```elixir
  {:ok, @module_model} = @module_model.update_by_opts(%{id: 1}, %{name: ""})
  ```
  """
  @callback update_by_opts(
              get_opts :: map() | keyword(),
              update_opts :: keyword() | map(),
              attrs :: list()
            ) ::
              {:ok, struct()}
              | {:error, Ecto.Changeset.t()}
              | {:error, :not_found}
              | {:error, any()}

  @doc """
  do @module_model.get!() if got and  do @module_model.update!()
  if error raise
  ### example

  ```elixir
  @module_model = @module_model.update_by_opts!(%{id: 1}, %{name: ""})
  ```
  """
  @callback update_by_opts!(
              get_opts :: map() | keyword(),
              update_opts :: keyword() | map(),
              attrs :: list()
            ) ::
              struct()

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

      @extensions_events_additional opts[:extensions_events_additional] || []
      @extensions_get_additional opts[:extensions_get_additional] || []
      @extensions_events (opts[:extensions_events] || []) ++ @extensions_events_additional
      @extensions_get (opts[:extensions_events] || []) ++ @extensions_get_additional

      @ignore_fields opts[:ignore_fields] || []
      @not_found_message opts[:error_message] || :not_found

      if length(@extensions_get) == 0 do
        :logger.warning("extensions_get give [], expect [Some.Extesnisons]")
      end

      use EctoForge.Helpers.QueryBinderGet,
        repo: @repo,
        extensions_get: opts[:extensions_get],
        module_model: @module_model

      def create(map) do
        map = ExecuteExtensionEvents.exucute_before_created(map, @extensions_events)

        @module_model.changeset(%@module_model{}, map)
        |> @repo.insert()
        |> ExecuteExtensionEvents.exucute_after_created(@extensions_events)
      end

      def create(map, function) when is_atom(function) do
        map = ExecuteExtensionEvents.exucute_before_created(map, @extensions_events)

        apply(@module_model, function, [%@module_model{}, map])
        |> @repo.insert()
        |> ExecuteExtensionEvents.exucute_after_created(@extensions_events)
      end

      def create!(map) do
        map = ExecuteExtensionEvents.exucute_before_created!(map, @extensions_events)

        @module_model.changeset(%@module_model{}, map)
        |> @repo.insert!()
        |> ExecuteExtensionEvents.exucute_after_created!(@extensions_events)
      end

      def create!(map, function) when is_atom(function) do
        map = ExecuteExtensionEvents.exucute_before_created!(map, @extensions_events)

        res =
          apply(@module_model, function, [%@module_model{}, map])
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

      def find(opts) when is_list(opts) or is_map(opts) do
        try do
          query_bindings(opts, :one)
        rescue
          Ecto.Query.CastError -> nil
        end
        |> get_helper_after
      end

      def get(item_id_or_opts) do
        case find(item_id_or_opts) do
          %@module_model{} = item -> {:ok, item}
          nil -> {:error, @not_found_message}
        end
      end

      def get!(item_id_or_opts) do
        case find(item_id_or_opts) do
          %@module_model{} = item -> item
          nil -> raise(%Ecto.NoResultsError{message: "#{inspect(@module_model)} not found"})
        end
      end

      def get_or_insert(attrs_get, attrs_create) do
        case get(attrs_get) do
          {:ok, user} -> {:ok, user}
          {:error, _} -> create(attrs_create)
        end
      end

      def exists?(opts) when is_list(opts) or is_map(opts) do
        get!(opts)
        |> @repo.exists?()
      end

      def find_all(opts \\ nil) do
        try do
          query_bindings(opts, :all)
        rescue
          Ecto.Query.CastError -> []
        end
        |> get_helper_after
      end

      def get_all(opts \\ nil) do
        case find_all(opts) do
          [] -> {:error, @not_found_message}
          items -> {:ok, items}
        end
      end

      def get_all!(item_id_or_opts \\ nil) do
        case find_all(item_id_or_opts) do
          [] -> throw(%Ecto.NoResultsError{message: "#{inspect(%@module_model{})} not found"})
          items -> items
        end
      end

      def update_with_another_changeset(%@module_model{} = item, opts, function_atom, attrs \\ [])
          when is_atom(function_atom) do
        opts = ExecuteExtensionEvents.exucute_before_updated!(opts, @extensions_events)

        res =
          apply(@module_model, function_atom, [item, opts])
          |> @repo.update(attrs)
          |> ExecuteExtensionEvents.exucute_after_updated!(@extensions_events)
      end

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

      def update(%@module_model{} = item, opts, attrs \\ []) do
        opts = ExecuteExtensionEvents.exucute_before_updated(opts, @extensions_events)

        res =
          item
          |> @module_model.changeset(opts)
          |> @repo.update(attrs)
          |> ExecuteExtensionEvents.exucute_after_updated(@extensions_events)
      end

      def update!(%@module_model{} = item, opts, attrs \\ []) do
        opts = ExecuteExtensionEvents.exucute_before_updated!(opts, @extensions_events)

        item
        |> @module_model.changeset(opts)
        |> @repo.update!(attrs)
        |> ExecuteExtensionEvents.exucute_after_updated!(@extensions_events)
      end

      def update_by_opts(get_opts, update_opts, attrs \\ []) do
        with {:ok, item} <- get(get_opts),
             {:ok, item} <- update(item, update_opts, attrs) do
          {:ok, item}
        end
      end

      def update_by_opts!(get_opts, update_opts, attrs \\ []) do
        res =
          get!(get_opts)
          |> update!(update_opts, attrs)
      end

      def delete(%@module_model{} = item) do
        item = ExecuteExtensionEvents.exucute_before_deleted(item, @extensions_events)

        try do
          @repo.delete(item)
          |> ExecuteExtensionEvents.exucute_after_deleted(@extensions_events)
        rescue
          err -> {:error, err}
        end
      end

      def delete!(%@module_model{} = item) do
        ExecuteExtensionEvents.exucute_before_deleted!(item, @extensions_events)

        res =
          @repo.delete!(item)
          |> ExecuteExtensionEvents.exucute_after_deleted!(@extensions_events)
      end

      def delete!(item_id_or_opts) when is_map(item_id_or_opts) or is_binary(item_id_or_opts) do
        get!(item_id_or_opts)
        |> delete!()
      end

      def delete(item_id_or_opts) do
        with {:ok, item} <- get(item_id_or_opts),
             {:ok, item} <- delete(item) do
          {:ok, item}
        end
      end

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
