defmodule Frezu.Repo.Migrations.AnchotVatText do
  use Ecto.Migration

  def change do
    alter table(:resources_anchor) do
      modify :title, :text
      modify :target, :text
    end
  end
end
