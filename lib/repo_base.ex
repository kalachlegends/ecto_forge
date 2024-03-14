defmodule EctoForge.DatabaseApi do
  alias EctoForge.Utls.ExecuteExtensionEvents

  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @module_model opts[:module_model] || __MODULE__
      @doc """
          ## Базовые функции для модели `#{@module_model}`

          ## Example
          ```elixir
          iex>  #{@module_model}.get_all(
            type_private: :public
          )
         ```

      """

      @repo opts[:repo]

      @extensions_events opts[:extensions_events]

      @ignore_fields opts[:ignore_fields] || []
      @extensions_get opts[:extensions_get] || []
      @not_found_message opts[:error_message] || :not_found

      use EctoForge.Helpers.QueryBinderGet,
        repo: @repo,
        extensions_get: opts[:extensions_get],
        module_model: @module_model

      @doc """
      ## Создает и делает insert структуры по дефолту дергает функцию changeset из `#{@module_model}`

      Возвращает `{:ok, item}` или `{:error, error_changeset}`
      ## Example
      ```
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
      ## Создает и делает insert структуры, вместе функцией changeset

      Возвращает `{:ok, item}` или `{:error, error_changeset}`
      ## Example
      ```
      #{@module_model}.create(%{name: "artem"}, :changeset_register)

      ```

      """
      def create(map, function) do
        map = ExecuteExtensionEvents.exucute_before_created(map, @extensions_events)

        apply(@module_model, function, [map])
        |> @repo.insert()
        |> ExecuteExtensionEvents.exucute_after_created(@extensions_events)
      end

      @doc """
      ## Создает и делает insert структуры по дефолту дергает функцию changeset из `#{@module_model}`

      Возвращает `{:ok, item}` или `{:error, error_changeset}`
      ## Example
      ```
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
      ## Создает и делает insert структуры, вместе функцией changeset

      Возвращает `{:ok, item}` или `{:error, error_changeset}`
      ## Example
      ```
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
      # Возвращает все поля в scheme


      ## Example
      ```
      iex> #{@module_model}.fields()
      [:id, :name]

      ```

      ## Можно фильтровать значения которые не нужны
      ```
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
      Возвращает структуру по ее id или по соответствию значения полей структуры
      """
      def find(opts) when is_list(opts) or is_map(opts) do
        try do
          query_bindings(opts, :one)
        rescue
          Ecto.Query.CastError -> nil
        end
        |> get_helper_after
      end

      def find(item_id) do
        try do
          query_bindings([id: item_id], :all)
        rescue
          Ecto.Query.CastError -> nil
        end
        |> get_helper_after
      end

      @doc """
      ## Возвращает структуру по ее id или по соответствию значения полей структуры

      ## Example
      ```
      #{@module_model}.get(
        type_private: :public,
      )
      ```
      """
      def get(item_id_or_opts) do
        case find(item_id_or_opts) do
          %@module_model{} = item -> {:ok, item}
          nil -> {:error, @not_found_message}
        end
      end

      @doc """
      ## Возвращает структуру по ее id или по соответствию значения полей структуры либо выдает ошибку `Ecto.NoResultsError`

      ## Example
      ```
      #{@module_model}.get!(
        type_private: :public,
      )
      ```
      """
      def get!(item_id_or_opts) do
        case find(item_id_or_opts) do
          %@module_model{} = item -> item
          nil -> throw(%Ecto.NoResultsError{message: "#{inspect(%@module_model{})} not found"})
        end
      end

      @doc """
      ## Получает или добавляет запись если не найдена
      ## Example
      ```
      #{@module_model}.get_or_insert(%{user_id: ""}, %{login: "12", password: "1234"})
      ```

      """
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

      @doc """
      ## Возвращает список всех имеющихся структур или по соответствию значения полей структуры
      ## Самое главное что нужно понять
      В get_all можно передать map или keyword list все будет попадать where
      #{@module_model}.get_all(%{status: 1})
      будет приравниваться `#{@module_model}|> where(%{status: 1)`

      #{@module_model}.get_all(%{preload: [:user]})
      будет приравниваться `#{@module_model}|> preload( [:user])`
      ## Example
      ```
      #{@module_model}.get_all(
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
      ## Возвращает список всех имеющихся структур или по соответствию значения полей структуры
      """

      def get_all(opts \\ nil) do
        case find_all(opts) do
          [] -> {:error, @not_found_message}
          items -> {:ok, items}
        end
      end

      @doc """
      ## Вовзращает либо ошибку либо результат выполнения find_all
      ## Example
      ```
      #{@module_model}.get_all!(
        type_private: :public,
      )
      ```
      """
      def get_all!(item_id_or_opts \\ nil) do
        case find_all(item_id_or_opts) do
          [] -> throw(%Ecto.NoResultsError{message: "#{inspect(%@module_model{})} not found"})
          items -> items
        end
      end

      @doc """
      ## Обновление структуры вместе с другим changeset

      iex ->  update_with_another_changeset(#{@module_model}, %{update_attrs: ""}, :function_in_changeset)

      третий аргумент функция которая находиться в модуле
      """
      def update_with_another_changeset(%@module_model{} = item, opts, function_atom, attrs \\ [])
          when is_atom(function_atom) do
        res =
          apply(@module_model, function_atom, [item, opts])
          |> @repo.update(attrs)
      end

      @doc """
      ## Обновление структуры вместе с другим changeset выкидывает throw

      iex ->  update_with_another_changeset!(#{@module_model}, %{update_attrs: ""}, :function_in_changeset)

      третий аргумент функция которая находиться в модуле
      """
      def update_with_another_changeset!(
            %@module_model{} = item,
            opts,
            function_atom,
            attrs \\ []
          )
          when is_atom(function_atom) do
        res =
          apply(@module_model, function_atom, [item, opts])
          |> @repo.update!(attrs)
      end

      @doc """
      ## Обновляет запись по item, %{}
      iex ->  update(#{@module_model}, %{update_attrs: ""}, repo.update)
      """
      def update(%@module_model{} = item, opts, attrs \\ []) do
        res =
          item
          |> @module_model.changeset(EctoForge.Helpers.RepoBase.Utls.MapUtls.opts_to_map(opts))
          |> @repo.update(attrs)
      end

      @doc """
      ## Обновляет запись по item, %{}, выкидывает исключение
      iex ->  `update!(#{@module_model}, %{update_attrs: ""}, repo.update)`
      """
      def update!(%@module_model{} = item, opts, attrs \\ []) do
        res =
          item
          |> @module_model.changeset(EctoForge.Helpers.RepoBase.Utls.MapUtls.opts_to_map(opts))
          |> @repo.update!(attrs)
      end

      @doc """
      ## Получает структуру c помощью #{@module_model}.get(get_opts) и обновляет

      iex ->  update_by_opts(#{@module_model} %{update_attrs: "asd"}, []) третий параметр для

      ## Возвращает
      {:ok, _}
      {:error, _}
      """
      def update_by_opts(get_opts, update_opts, attrs \\ []) do
        res =
          with {:ok, item} <- get(get_opts),
               {:ok, item} <- update(item, update_opts, attrs) do
            {:ok, item}
          end
      end

      @doc """
      ## Получает структуру c помощью #{@module_model}.get(get_opts) и обновляет

      iex ->  update_by_opts(#{@module_model} %{update_attrs: "asd"}, []) третий параметр для

      """
      def update_by_opts!(get_opts, update_opts, attrs \\ []) do
        res =
          get!(get_opts)
          |> update!(update_opts, attrs)
      end

      @doc """
      ## Удаляет запись по id, item, #{@module_model} или map

      ## Возвращает
      {:ok, _}
      {:error, _}
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

      def delete!(%@module_model{} = item) do
        ExecuteExtensionEvents.exucute_before_deleted!(item, @extensions_events)

        res =
          @repo.delete!(item)
          |> ExecuteExtensionEvents.exucute_after_deleted!(@extensions_events)
      end

      @doc """
      ## получает структуру и удаляет ее с помощью функций #{@module_model}.get(%{}) |> #{@module_model}.delete
      """
      def delete!(item_id_or_opts) when is_map(item_id_or_opts) or is_binary(item_id_or_opts) do
        get!(item_id_or_opts)
        |> delete!()
      end

      @doc """
      ## получает структуру и удаляет ее с помощью функций #{@module_model}.get(%{}) |> #{@module_model}.delete
      """
      def delete(item_id_or_opts) do
        with {:ok, item} <- get(item_id_or_opts),
             {:ok, item} <- delete(item) do
          {:ok, item}
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
