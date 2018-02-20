defmodule Frezu.Repo.Migrations.AddHrefToAnchor do
  use Ecto.Migration

  def change do
    alter table(:resources_anchor) do
      add :href, :text
    end
  end
end
