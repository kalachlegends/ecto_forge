defmodule EctoForge.Repo.Migrations.UsersPost do
  use Ecto.Migration

  def change do
    create table("user_posts") do
      add(:title, :string)
      add(:description, :string)
      add :user_id, references(:user)
    end
  end
end
