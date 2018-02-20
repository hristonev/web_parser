defmodule Frezu.ResourceMetaDescription do
  @moduledoc false
  use Frezu.Web, :model

  schema "resources_meta_description" do
    field :value, :string
    belongs_to :resource, Frezu.Resource
  end
end
