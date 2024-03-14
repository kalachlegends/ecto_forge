defmodule EctoForge.CreateInstance do
  @moduledoc """
  ## Create your instanse EctoForge and use for your context or Models

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
  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @repo opts[:repo]
      @extensions_events opts[:extensions_events]
      @extensions_api opts[:extensions_api]
      @extensions_get opts[:extensions_get] || []

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
    end
  end
end
