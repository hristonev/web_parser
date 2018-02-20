defmodule Frezu.Repo.Migrations.ResizeUrlResource do
  use Ecto.Migration

  def change do
    alter table(:resources) do
      modify :url, :text
    end
  end
end
