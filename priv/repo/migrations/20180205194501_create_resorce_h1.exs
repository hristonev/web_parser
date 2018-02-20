defmodule Frezu.Repo.Migrations.CreateResorceH1 do
  use Ecto.Migration

  def change do
    create table(:resources_h1) do
      add :value, :string
      add :resource_id, references(:resources, on_delete: :delete_all)
    end
    create index(:resources_h1, [:resource_id])
  end
end
