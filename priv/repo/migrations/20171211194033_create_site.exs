defmodule Frezu.Repo.Migrations.CreateSite do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :url, :string
      add :limit, :integer
      add :depth, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:sites, [:user_id])
  end
end
