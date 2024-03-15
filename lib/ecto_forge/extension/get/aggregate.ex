defmodule EctoForge.Extension.Get.Aggregate do
  @moduledoc """
  ## Use aggregate with your model
  ### Example
  ```
  ```
  ### Usage

  ```elixir
  use EctoForge.CreateInstance,
    extensions_get: [
      EctoForge.Extension.Get.Aggregate,
    ],
    repo: MyApp.Repo

  ### Using with model

  ```
  ```

  """
  # import Ecto.Query
  use EctoForge.CreateExtension.Get

  def after_query_add_extension_to_get(module, mode, repo, prev_query, result, attrs) do
    {prev_query, result, attrs}
  end
end
