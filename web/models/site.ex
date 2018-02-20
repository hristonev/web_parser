defmodule Frezu.Site do
  use Frezu.Web, :model

  schema "sites" do
    field :url, :string
    field :delay, :integer
    field :user_agent, :string
    belongs_to :user, Frezu.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :delay, :user_agent])
    |> validate_required([:url, :delay, :user_agent])
  end
end
