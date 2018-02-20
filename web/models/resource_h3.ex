defmodule Frezu.ResourceH3 do
  @moduledoc false
  use Frezu.Web, :model

  schema "resources_h3" do
    field :value, :string
    belongs_to :resource, Frezu.Resource
  end
end
