defmodule Frezu.Anchor do
  @moduledoc false
  use Frezu.Web, :model

  schema "anchors" do
    field :value, :string
    field :title, :string
    field :href, :string
    field :target, :string
    field :rel, :string
    field :html, :string
    field :hash, :string
  end
end
