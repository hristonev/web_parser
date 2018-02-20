defmodule Frezu.ResourceTitle do
  @moduledoc false
  use Frezu.Web, :model

  schema "resources_title" do
    field :value, :string
    belongs_to :resource, Frezu.Resource
  end
end
