defmodule Frezu.Repo.Migrations.CreateMirror do
  use Ecto.Migration

  def change do
    create table(:mirrors) do
      add :html, :boolean
      add :resource, :boolean
      add :image, :boolean
      add :site_id, references(:sites, on_delete: :nothing)

      timestamps()
    end
    create index(:mirrors, [:site_id])
  end
end
