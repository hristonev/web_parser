defmodule Frezu.Parser do
  @moduledoc false
  use Frezu.Web, :channel
  alias Ecto.Multi
  alias Frezu.{Resource}

  def parse(url, %{body: body, headers: headers, status_code: status_code}, mirror, response_time) do
    {:ok, struct} = Resource.create(%Resource{}, %{
      url: url,
      status_code: status_code,
      hash: get_hash(body),
      size: byte_size(body),
      headers: headers |> Enum.into(%{}),
      mirror: mirror,
      response_time: response_time,
      anchors: parse_anchor(body)
    })

    case status_code do
      x when x in 200..299 -> parse_body(body, struct.resources)
      _ -> {:ok, "Not parsed!"}
    end
  end

  defp parse_body(body, resource) do
    title = body
    |> Floki.find("title")
    |> Enum.map(fn tag -> [value: Floki.text(tag), resource_id: resource.id] end)

    robots = body
    |> Floki.find("meta[name='robots']")
    |> Floki.attribute("content")
    |> Enum.map(fn text -> [value: text, resource_id: resource.id] end)

    keywords = body
    |> Floki.find("meta[name='keywords']")
    |> Floki.attribute("content")
    |> Enum.map(fn text -> [value: text, resource_id: resource.id] end)

    description = body
    |> Floki.find("meta[name='description']")
    |> Floki.attribute("content")
    |> Enum.map(fn text -> [value: text, resource_id: resource.id] end)

    h3 = body
    |> Floki.find("h3")
    |> Enum.map(fn tag -> [value: Floki.text(tag), resource_id: resource.id] end)

    h2 = body
    |> Floki.find("h2")
    |> Enum.map(fn tag -> [value: Floki.text(tag), resource_id: resource.id] end)

    h1 = body
    |> Floki.find("h1")
    |> Enum.map(fn tag -> [value: Floki.text(tag), resource_id: resource.id] end)

    multi = Multi.new()
    |> Multi.insert_all(:resources_title, Frezu.ResourceTitle, title)
    |> Multi.insert_all(:resources_meta_robot, Frezu.ResourceMetaRobot, robots)
    |> Multi.insert_all(:resources_meta_keyword, Frezu.ResourceMetaKeyword, keywords)
    |> Multi.insert_all(:resources_meta_description, Frezu.ResourceMetaDescription, description)
    |> Multi.insert_all(:resources_h3, Frezu.ResourceH3, h3)
    |> Multi.insert_all(:resources_h2, Frezu.ResourceH2, h2)
    |> Multi.insert_all(:resources_h1, Frezu.ResourceH1, h1)
#    |> Multi.insert_all(:resources_anchor, Frezu.ResourceAnchor, a)
    Repo.transaction(multi)

    {:ok}
  end

  defp parse_anchor(body) do
    body
    |> Floki.find("a")
    |> Enum.map(
      fn tag -> [
        value: Floki.text(tag),
        href: get_tag_attr(tag, "href"),
        title: get_tag_attr(tag, "title"),
        target: get_tag_attr(tag, "target"),
        rel: get_tag_attr(tag, "rel"),
        html: Floki.raw_html(tag),
        hash: get_hash(Floki.raw_html(tag)),
      ] end)
  end

  defp get_tag_attr(tag, attr) do
    case Floki.attribute(tag, attr) do
      [] ->
        "n/a"
      value_list ->
        value_list |> List.first
    end
  end

  defp get_hash(str), do: Base.encode16(:crypto.hash(:sha256,str), case: :lower)
end
