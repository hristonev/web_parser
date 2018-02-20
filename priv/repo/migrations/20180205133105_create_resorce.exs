defmodule Frezu.Repo.Migrations.CreateResorce do
  use Ecto.Migration

  def change do
    create table(:resources) do
      add :url,         :string
      add :status_code, :integer
      add :hash,        :string
      add :size,        :integer
      add :headers,     {:map, :string}
      add :mirror_id, references(:mirrors, on_delete: :delete_all)

      timestamps()
    end
    create index(:resources, [:mirror_id])
  end
end
