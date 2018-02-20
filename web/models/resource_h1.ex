defmodule Frezu.ResourceH1 do
  @moduledoc false
  use Frezu.Web, :model

  schema "resources_h1" do
    field :value, :string
    belongs_to :resource, Frezu.Resource
  end
end
