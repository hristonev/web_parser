defmodule Frezu.Repo.Migrations.Site do
  use Ecto.Migration

  def change do
    rename table(:sites), :limit, to: :delay
    rename table(:sites), :depth, to: :user_agent
    alter table(:sites) do
      modify :user_agent, :string
    end
  end
end
