defmodule EctoForge.CreateInstance do
  alias EctoForge.Utls.ExecuteExtension

  @moduledoc """
  ## Create your instanse EctoForge and use for your context or Models
  This module creates an instance with functions from `EctoForge.DatabaseApi`
  ### Using
  ```elixir
  defmodule MyApp.EctoForgeInstanse do
   use EctoForge.CreateInstance,
    extensions_events: [Test.Event.ExtensionDeleteId],
    extensions_get: [
      EctoForge.Extension.Get.Preload,
      EctoForge.Extension.Get.Filter,
      EctoForge.Extension.Get.Pagination
    ],
    repo: EctoForge.Repo
  end
  ```
  #### Connect to your model

  ```elixir
  defmodule EctoForgeTest.UserModel do
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  schema "user" do
    field(:name, :string)
    # timestamps()
  end

  use EctoForge.CreateInstance
  @doc false

  def changeset(emails_model \\ %__MODULE__{}, attrs) do
    emails_model
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
  end
  ```

  #### Connect to your context

  ```elixir
  defmodule MyApp.Context.UserModel do
  use MyApp.EctoForgeInstanseBase, module_model: MyApp.UserModel
  end

  ```
  """
  @doc """
  # Do execute your extension without connect to model

  ## Example

  ```elixir
  [%UserModel{}] = execute_extension(from(user in UserModel), :all, %{
        filter: %{name: "arte"}
      })
  ```
  """
  @callback execute_extension(
              mode :: atom() | :all | :one,
              query :: Ecto.Query.t(),
              attrs :: map() | keyword(),
              module :: module()
            ) :: map() | struct() | list() | nil
  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @repo opts[:repo]
      @extensions_events opts[:extensions_events]
      @extensions_api opts[:extensions_api]
      @extensions_get opts[:extensions_get] ||
                        EctoForge.Extension.Default.all_list_extensions_get()
      @behaviour EctoForge.CreateInstance
      defmacro __using__(opts_for_module) do
        quote location: :keep do
          opts_for_module = unquote(opts_for_module)

          use(
            EctoForge.DatabaseApi,
            [
              repo: unquote(@repo),
              extensions_api: unquote(@extensions_api),
              extensions_get: unquote(@extensions_get),
              extensions_events: unquote(@extensions_events)
            ] ++
              unquote(opts_for_module)
          )
        end
      end

      def execute_extension(query, mode \\ :all, attrs \\ %{}, module \\ __MODULE__) do
        result =
          case ExecuteExtension.extensions_get_before_exucute(
                 module,
                 @extensions_get,
                 mode,
                 @repo,
                 [],
                 query,
                 attrs
               ) do
            {new_query, attrs} ->
              result = apply(@repo, mode, [new_query])

              {_prev_query, result, _attrs} =
                ExecuteExtension.extensions_get_after_exucute(
                  module,
                  @extensions_get,
                  mode,
                  @repo,
                  [],
                  new_query,
                  result,
                  attrs
                )

              result

            {:result, result, prev_query, _attrs} ->
              {prev_query, result, attrs} =
                ExecuteExtension.extensions_get_after_exucute(
                  module,
                  @extensions_get,
                  @repo,
                  [],
                  prev_query,
                  mode,
                  result,
                  attrs
                )

              result
          end

        result
      end
    end
  end
end
