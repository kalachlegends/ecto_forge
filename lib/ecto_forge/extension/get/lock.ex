defmodule EctoForge.Extension.Get.Lock do
  @moduledoc """
  # You can use Api https://hexdocs.pm/ecto/Ecto.Query.html#lock/3

  ```
  %{} = MyApp.Model.find(filter: %{id: 1}, lock: "FOR SHARE NOWAIT")
  ```
  """
  import Ecto.Query
  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, _repo, _l_ex, query, nil) do
    {query, %{}}
  end

  def before_query_add_extension_to_get(module, _mode, _repo, _l_ex, query, attrs) do
    lock_attrs = Access.get(attrs, :lock)

    supported_locks = [
      "FOR SHARE NOWAIT",
      "FOR KEY SHARE",
      "FOR UPDATE",
      "FOR NO KEY UPDATE",
      "FOR SHARE",
      "FOR UPDATE NOWAIT",
      "FOR UPDATE SKIP LOCKED"
    ]

    if is_binary(lock_attrs) do
      cond do
        lock_attrs == "FOR SHARE NOWAIT" ->
          {lock(query, "FOR SHARE NOWAIT"), attrs}

        lock_attrs == "FOR KEY SHARE" ->
          {lock(query, "FOR KEY SHARE"), attrs}

        lock_attrs == "FOR UPDATE" ->
          {lock(query, "FOR UPDATE"), attrs}

        lock_attrs == "FOR UPDATE NOWAIT" ->
          {lock(query, "FOR UPDATE NOWAIT"), attrs}

        lock_attrs == "FOR NO KEY UPDATE" ->
          {lock(query, "FOR NO KEY UPDATE"), attrs}

        lock_attrs == "FOR SHARE" ->
          {lock(query, "FOR SHARE"), attrs}

        lock_attrs == "FOR UPDATE SKIP LOCKED" ->
          {lock(query, "FOR UPDATE SKIP LOCKED"), attrs}

        true ->
          raise EctoForge.Expections.NotSupport,
            message: """

            This lock isn't support because of Ecto.Query accept or literally string ask developer of EctoForge to add your expression
            this locks have support:
            #{inspect(supported_locks)}
            instead of this #{module}.find(filter: %{id: 1, lock: #{lock_attrs}}) you can use this:
            #{module}.find(filter: %{id: 1, query_function: fn your_query -> Ecto.Query.lock(your_query, "FOR SHARE") end})
            """
      end
    else
      {query, attrs}
    end
  end
end
