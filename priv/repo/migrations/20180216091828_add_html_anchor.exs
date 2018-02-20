defmodule Frezu.Repo.Migrations.AddHtmlAnchor do
  use Ecto.Migration

  def change do
    alter table(:resources_anchor) do
      add :html, :text
    end
  end
end
