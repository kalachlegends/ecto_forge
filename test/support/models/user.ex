defmodule EctoForgeTest.UserModel do
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{}

  schema "user" do
    field(:name, :string)
    has_many(:posts, EctoForgeTest.PostModel, foreign_key: :user_id)
    # timestamps()
  end

  use Support.EctoForgeInstanceTest
  @doc false

  def changeset(emails_model \\ %__MODULE__{}, attrs) do
    emails_model
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
