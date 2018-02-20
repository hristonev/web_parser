defmodule Frezu.Repo.Migrations.AddResponseTimeResource do
  use Ecto.Migration

  def change do
    alter table(:resources) do
      add :response_time, :integer
    end
  end
end
