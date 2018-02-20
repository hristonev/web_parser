defmodule Frezu.Repo.Migrations.CreateResorceTitle do
  use Ecto.Migration

  def change do
    create table(:resources_title) do
      add :value, :string
      add :resource_id, references(:resources, on_delete: :delete_all)
    end
    create index(:resources_title, [:resource_id])
  end
end
