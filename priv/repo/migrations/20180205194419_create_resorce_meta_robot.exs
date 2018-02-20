defmodule Frezu.Repo.Migrations.CreateResorceMetaRobot do
  use Ecto.Migration

  def change do
    create table(:resources_meta_robot) do
      add :value, :string
      add :resource_id, references(:resources, on_delete: :delete_all)
    end
    create index(:resources_meta_robot, [:resource_id])
  end
end
