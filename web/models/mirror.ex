defmodule Frezu.Mirror do
  @moduledoc false
  use Frezu.Web, :model

  schema "mirrors" do
    field :html, :boolean
    field :resource, :boolean
    field :image, :boolean
    belongs_to :site, Frezu.Site
    timestamps()
  end
end
