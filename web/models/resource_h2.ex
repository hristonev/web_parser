defmodule Frezu.ResourceH2 do
  @moduledoc false
  use Frezu.Web, :model

  schema "resources_h2" do
    field :value, :string
    belongs_to :resource, Frezu.Resource
  end
end
