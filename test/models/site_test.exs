defmodule Frezu.SiteTest do
  use Frezu.ModelCase

  alias Frezu.Site

  @valid_attrs %{/: "some content", depth: 42, limit: 42, url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Site.changeset(%Site{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Site.changeset(%Site{}, @invalid_attrs)
    refute changeset.valid?
  end
end
