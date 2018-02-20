defmodule Frezu.ResourceMetaKeyword do
  @moduledoc false
  use Frezu.Web, :model

  schema "resources_meta_keyword" do
    field :value, :string
    belongs_to :resource, Frezu.Resource
  end
end
