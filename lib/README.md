        ## Базовые функции для модели `#{__MODULE__}`

          ## Example
          ```
          iex>  #{__MODULE__}.get_all(
            type_private: :public, # все поля которые не в use_query попадают в where
            use_query: %{
              order_by: [asc: :inserted_at]
              preload: [:user, :tree],
             search: %{
              key: name,
              value: "value"
              },
             pagination: %{
              page: page,
              limit: limit
              }
            }
          )
          # Если есть пагинация вернет мапу с количеством
          {:ok, %{count: 2, item: []}}

          # в use_query можно использовать select:
          # Если его не будет вернет все поля данной схемы
          # Example:
          #{__MODULE__}.get_all(
              use_query: %{
                preload: [:user]
                select: [user: :login, :id] +   #{__MODULE__}.fields()
              }
            }
          )

          # Чтобы не перечислять все поля можно использовать

          #{__MODULE__}.fields()

          # если надо использовать дополнительные функции то можно испольльзовать ключ query_function
          # Он принимает в себя функцию которая принимает запрос Ecto.Query
          #{__MODULE__}.get_all(
              use_query: %{
                preload: [:user]
                query_function: fn query ->
                  query
                  |> where([w], w.id == 1)
                end
              }
            }
          )

          ```

          ## В Этом модуле так же есть

          ```
          #{__MODULE__}.update_by_id(id, map)
          {:ok, item} ||   {:error, reason}
          ```
          ## В use_query можно использовать для подсчета выдаст количество элементов по значению
          ```

              aggregate_attrs: %{
                aggregate: :count,
                attrs: :id
              },
          ```
