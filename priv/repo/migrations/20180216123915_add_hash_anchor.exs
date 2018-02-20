defmodule Frezu.Repo.Migrations.AddHashAnchor do
  use Ecto.Migration

  def change do
    alter table(:resources_anchor) do
      add :hash, :string
      add :mirror_id, references(:mirrors, on_delete: :delete_all)
    end
  end
end
