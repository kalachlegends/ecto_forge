defmodule EctoForgeTest.PostModelWithLogger do
  import EctoForge.Extension.Events.Logger.MacroLogger
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  schema "user_posts" do
    field(:title, :string)
    field(:description, :string)
    belongs_to(:user, EctoForgeTest.UserModel)
  end

  use Support.EctoForgeInstanceTest,
    extensions_events_additional: [
      define_log(TestModule, message: "govno")
    ]

  @doc false

  def changeset(emails_model \\ %__MODULE__{}, attrs) do
    emails_model
    |> cast(attrs, [:title, :description, :user_id])
    |> validate_required([:title, :description, :user_id])
  end
end
