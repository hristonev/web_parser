defmodule Frezu.Repo.Migrations.CreateResorceMetaKeyword do
  use Ecto.Migration

  def change do
    create table(:resources_meta_keyword) do
      add :value, :string
      add :resource_id, references(:resources, on_delete: :delete_all)
    end
    create index(:resources_meta_keyword, [:resource_id])
  end
end
