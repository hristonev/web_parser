defmodule Frezu.Resource do
  @moduledoc false
  use Frezu.Web, :model
  alias Ecto.Multi
  alias Frezu.{Repo, Mirror, Anchor}

  @allowed_params [:url, :status_code, :hash, :size, :headers, :response_time]

  schema "resources" do
    field :url,           :string
    field :status_code,   :integer
    field :hash,          :string
    field :size,          :integer
    field :headers,       {:map, :string}
    field :response_time, :integer
    belongs_to :mirror, Mirror
    many_to_many :anchors, Anchor, join_through: "resources_anchor"
    timestamps()
  end

    def changeset(struct, params) do
      struct
      |> Ecto.Changeset.cast(params, @allowed_params)
    end

    def create(struct, params) do
      Multi.new()
      |> Multi.run(:anchors, &insert_and_get_anchors(&1, params.anchors))
      |> Multi.run(:resources, &insert_and_get_resorce(&1, struct, params))
      |> Repo.transaction()
    end

    defp insert_and_get_resorce(%{anchors: anchors}, struct, params) do
      Frezu.Resource.changeset(struct, params)
      |> Ecto.Changeset.put_assoc(:mirror, params.mirror)
      |> Ecto.Changeset.put_assoc(:anchors, anchors)
      |> Repo.insert()
    end

    defp insert_and_get_anchors(_, []), do: {:ok, []}
    defp insert_and_get_anchors(_, anchors) do
      hashes = Enum.map(anchors, &(&1[:hash]))
      Repo.insert_all(Anchor, anchors, on_conflict: :nothing)
      {:ok, Repo.all(from a in Anchor, where: a.hash in ^hashes)}
    end
end
