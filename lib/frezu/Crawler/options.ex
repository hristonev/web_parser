defmodule Frezu.Crawler.Options do
  @moduledoc false

  def asign(opt) do
    Map.merge(%{
      parsed_urls: []
    }, opt)
  end

end
