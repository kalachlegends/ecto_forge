defmodule EctoForge.CreateExtension.Get do
  @moduledoc """

  # You can use callback functions for processing. After the query and before the query to filter the data.

  ```elixir
  defmodule EctoForge.Extension.Get.Preload do

  use EctoForge.CreateExtension.Get

  def before_query_add_extension_to_get(_module, _mode, query, attrs) do
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
              query :: Ecto.Query.t(),
              attrs :: map() | keyword()
            ) :: any()

  @callback after_query_add_extension_to_get(
              module :: atom(),
              mode :: atom(),
              query :: Ecto.Query.t(),
              attrs :: map() | keyword()
            ) :: any()
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour EctoForge.CreateExtension.Get

      def before_query_add_extension_to_get(module, mode, query, attrs) do
        {query, attrs}
      end

      def after_query_add_extension_to_get(module, mode, query, attrs) do
        {query, attrs}
      end

      defoverridable before_query_add_extension_to_get: 4
      defoverridable after_query_add_extension_to_get: 4
    end
  end
end
