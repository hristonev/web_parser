defmodule Frezu.Repo.Migrations.VarToText do
  use Ecto.Migration

  def change do
    alter table(:resources_title) do
      modify :value, :text
    end
    alter table(:resources_meta_robot) do
      modify :value, :text
    end
    alter table(:resources_meta_keyword) do
      modify :value, :text
    end
    alter table(:resources_meta_description) do
      modify :value, :text
    end
    alter table(:resources_h3) do
      modify :value, :text
    end
    alter table(:resources_h2) do
      modify :value, :text
    end
    alter table(:resources_h1) do
      modify :value, :text
    end
    alter table(:resources_anchor) do
      modify :value, :text
    end
  end
end
