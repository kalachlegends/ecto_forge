defmodule EctoForgeTest.PostModel do
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  schema "user_posts" do
    field(:title, :string)
    field(:description, :string)
    belongs_to(:user, EctoForgeTest.UserModel)
  end

  use Support.EctoForgeInstanceTest
  @doc false

  def changeset(emails_model \\ %__MODULE__{}, attrs) do
    emails_model
    |> cast(attrs, [:title, :description, :user_id])
    |> validate_required([:title, :description, :user_id])
  end
end
