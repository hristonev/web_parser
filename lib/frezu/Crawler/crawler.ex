defmodule Frezu.Crawler do
  @moduledoc false

  alias Frezu.Crawler.{Options}
  use Retry

  def crawl(url, opt \\ []) do
    start_time = :os.system_time(:seconds)
    summary = opt
    |> Enum.into( %{} )
    |> Map.merge( %{start_url: url} )
    |> Options.asign()
    |> request(url)

    end_time = :os.system_time(:seconds)
    IO.inspect "Parsed URLs: " <> to_string(length(summary.parsed_urls))
    IO.inspect "Duration: " <> to_string(end_time - start_time)

    {:ok, %{}}
  end

  def request(opt, url) do
    {f_url, filter} = filter(url, opt)
    if (filter || Enum.member?(opt.parsed_urls, f_url)) do
      opt
    else
      headers = [{"User-Agent", opt.user_agent}]
      options = []#follow_redirect: true
      :timer.sleep(opt.delay)

      retrier(f_url, headers, options, opt)
    end
  end

  defp retrier(f_url, headers, options, opt) do
    retry with: exp_backoff() |> expiry(7_000) do
      timer(:start_request)
      f_url
      |> HTTPoison.get(headers, options)
      |> handle_response(f_url, Map.merge(opt, %{parsed_urls: opt.parsed_urls ++ [f_url]}))
    end
  end

  defp timer(key) do
    :erlang.put({:time, key}, :os.timestamp())
  end

  defp get_timings() do
    Enum.flat_map(:erlang.get(), fn
      {{:time, event} = key, time} ->
        :erlang.erase(key)
        [{event, time}]

      _ ->
        []
    end)
  end

  defp get_exec_time() do
    timings = get_timings()
    :timer.now_diff(timings[:end_request], timings[:start_request])
  end

  defp filter(url, opt) do
    uri_info = URI.parse(url)
    if is_nil(uri_info.scheme) do
      filter(opt.start_url <> url, opt)
    else
      if (!is_nil(uri_info.host) && String.equivalent?(uri_info.host, opt.host)) do
        {url, false}
      else
        {url, true}
      end
    end
  end

  def handle_response({:error, _}, url, opt) do
    IO.inspect :os.system_time(:seconds)
    IO.inspect "Timeout" <> " " <> url
    opt
  end

  # Status 2xx
  def handle_response(
        {:ok, %{body: body, headers: headers, status_code: status_code} = response},
        url,
        opt
      ) when status_code in 200..299 do
    timer(:end_request)
    exec_time = get_exec_time()
    content_type = headers
    |> Enum.into(%{})
    |> Map.get("Content-Type")
    if String.starts_with? content_type, "text/" do
      # Parse body. Store in DB.
      spawn fn -> Frezu.Parser.parse(url, response, opt.mirror, exec_time) end

      # Parse links
      body
      |> Floki.find("a")
      |> Floki.attribute("href")
      |> Enum.filter(fn(x) -> !String.match?(x, ~r/(\.jpg|\.jpeg|\.png|\.gif)$/i) end)
      |> Enum.uniq
      |> Enum.reduce(opt, fn(url, acc) -> request(acc, url) end)
    else
      opt
    end
  end

  defp get_location_header(headers) do
    for {key, value} <- headers, String.downcase(key) == "location" do
      value
    end
  end

  # Status 3xx
  def handle_response(
        {:ok, %{headers: headers, status_code: status_code} = response},
        url,
        opt
      ) when status_code in 300..399 do
    timer(:end_request)
    exec_time = get_exec_time()
    spawn fn -> Frezu.Parser.parse(url, response, opt.mirror, exec_time) end
    location = get_location_header(headers) |> List.first
    if !is_nil(location), do: request(opt, location)
  end

  # Status 1xx, 4xx, 5xx and other
  def handle_response(
        {:ok, %{headers: headers, status_code: status_code} = response},
        url,
        opt
      ) do
    timer(:end_request)
    exec_time = get_exec_time()
    spawn fn -> Frezu.Parser.parse(url, response, opt.mirror, exec_time) end
    opt
  end

  # Error
  def handle_response(
        {:error, %HTTPoison.Error{reason: reason}},
        url,
        opt
      ) do
    IO.inspect reason
    opt
  end
end
