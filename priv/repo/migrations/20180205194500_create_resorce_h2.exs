defmodule Frezu.Repo.Migrations.CreateResorceH2 do
  use Ecto.Migration

  def change do
    create table(:resources_h2) do
      add :value, :string
      add :resource_id, references(:resources, on_delete: :delete_all)
    end
    create index(:resources_h2, [:resource_id])
  end
end
