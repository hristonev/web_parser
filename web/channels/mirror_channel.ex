defmodule Frezu.MirrorChannel do
  use Frezu.Web, :channel

  alias Frezu.Site
  alias Frezu.Crawler

  def join("mirror_channel:" <> mirror_id, _params, socket) do
    case check_mirror_authority(mirror_id, socket) do
      {:ok, id} ->
        {:ok, assign(socket, :mirror_id, id)}
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp check_mirror_authority(mirror_id, socket) do
    site = Repo.get!(Site, String.to_integer(mirror_id))
    if site.user_id == socket.assigns.user_id do
      {:ok, site.id}
    else
      {:error, "You are not owner."}
    end
  end

  def handle_info(:ping, socket) do
    count = socket.assigns[:count] || 1
    push socket, "ping", %{count: count}
    {:noreply, assign(socket, :count, count + 1)}
  end

  def handle_in(event, params, socket) do
      user = Repo.get(Frezu.User, socket.assigns.user_id)
      handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    broadcast! socket, "new_annotation", %{
      user: Frezu.UserView.render("user.json", %{user: user}),
      cmd: params["cmd"],
      mirror: params["mirror"]
    }
    {:reply, :ok, socket}
  end

  def handle_in("cmd", params, user, socket) do
#    IO.inspect socket
    {:ok, opts} = command(params["cmd"], params["mirror"], params, user, socket)
    broadcast! socket, "cmd", %{
      user: Frezu.UserView.render("user.json", %{user: user}),
      cmd: params["cmd"],
      mirror: params["mirror"]
    }
    {:reply, :ok, assign(socket, :crawler, opts)}
  end

  defp command(cmd, mirror_id, params, user, socket) when cmd == "start" do
    site = Repo.get!(Site, mirror_id)
    uri_info = URI.parse(site.url)

    mirror_data = %Frezu.Mirror{
      html: false,
      resource: false,
      image: false,
      site: site
    }

    case Repo.insert(mirror_data) do
      {:ok, mirror} ->
        Crawler.crawl(
          site.url,
          host: uri_info.host,
          socket: socket,
          delay: site.delay,
          user_agent: site.user_agent,
          mirror: mirror
        )
      {:error, mirror} ->
        IO.inspect "Mirror insert fail!"
    end
    {:ok, %{}}
  end

  def broadcast(%{url: url, body: _, opts: opts} = page, type) do
    broadcast! opts.socket, "message", %{
      user: Frezu.UserView.render("user.json", %{user: opts.user}),
      type: type,
      txt: url,
      mirror: opts.params["mirror"]
    }
    {:reply, :ok, assign(opts.socket, :crawler, opts)}
  end

  def broadcast_txt(url, opts, type) do
    broadcast! opts.socket, "message", %{
      user: Frezu.UserView.render("user.json", %{user: opts.user}),
      type: type,
      txt: url,
      mirror: opts.params["mirror"]
    }
    {:reply, :ok, assign(opts.socket, :crawler, opts)}
  end

end
