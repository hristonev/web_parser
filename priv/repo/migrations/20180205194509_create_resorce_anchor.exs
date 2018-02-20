defmodule Frezu.Repo.Migrations.CreateResorceAnchor do
  use Ecto.Migration

  def change do
    create table(:resources_anchor) do
      add :value, :string
      add :title, :string
      add :target, :string
      add :rel, :string
      add :resource_id, references(:resources, on_delete: :delete_all)
    end
    create index(:resources_anchor, [:resource_id])
  end
end
