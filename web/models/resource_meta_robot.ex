defmodule Frezu.ResourceMetaRobot do
  @moduledoc false
  use Frezu.Web, :model

  schema "resources_meta_robot" do
    field :value, :string
    belongs_to :resource, Frezu.Resource
  end
end
