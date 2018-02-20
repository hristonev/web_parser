defmodule Frezu.Repo.Migrations.AddManyToManyAnchor do
  use Ecto.Migration

  def change do
    drop table(:resources_anchor)

    create table(:anchors) do
      add :value, :text
      add :title, :text
      add :target, :text
      add :rel, :string
      add :href, :text
      add :html, :text
      add :hash, :string
    end

    create unique_index(:anchors, [:hash])

    create table(:resources_anchor, primary_key: false) do
      add :resource_id, references(:resources)
      add :anchor_id, references(:anchors)
    end

  end
end
