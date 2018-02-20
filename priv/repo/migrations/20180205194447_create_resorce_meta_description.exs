defmodule Frezu.Repo.Migrations.CreateResorceMetaDescription do
  use Ecto.Migration

  def change do
    create table(:resources_meta_description) do
      add :value, :string
      add :resource_id, references(:resources, on_delete: :delete_all)
    end
    create index(:resources_meta_description, [:resource_id])
  end
end
