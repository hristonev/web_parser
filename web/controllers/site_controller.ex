defmodule Frezu.SiteController do
  use Frezu.Web, :controller

  alias Frezu.{Site, User}

  def index(conn, _params) do
    user_id = get_session(conn, :user_id)
    sites = Site
      |> where([s], s.user_id in [^user_id])
      |> Repo.all
    render(conn, "index.html", sites: sites)
  end

  def new(conn, _params) do
    user_agent = conn.req_headers
    |> Enum.into(%{})
    |> Map.get("user-agent")

    site = %Site{
      delay: 100,
      user_agent: user_agent
    }

    changeset = Site.changeset(site)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"site" => site_params}) do
    user = Repo.get(User, get_session(conn, :user_id))
    changeset = Site.changeset(%Site{}, site_params)
    |> Ecto.Changeset.put_assoc(:user, user)
#    IO.inspect changeset
    case Repo.insert(changeset) do
      {:ok, _site} ->
        conn
        |> put_flash(:info, "Site created successfully.")
        |> redirect(to: site_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
#    conn
  end

  def show(conn, %{"id" => id}) do
    site = Repo.get!(Site, id)
    render(conn, "show.html", site: site)
  end

  def edit(conn, %{"id" => id}) do
    site = Repo.get!(Site, id)
    changeset = Site.changeset(site)
    render(conn, "edit.html", site: site, changeset: changeset)
  end

  def update(conn, %{"id" => id, "site" => site_params}) do
    site = Repo.get!(Site, id)
    changeset = Site.changeset(site, site_params)

    case Repo.update(changeset) do
      {:ok, site} ->
        conn
        |> put_flash(:info, "Site updated successfully.")
        |> redirect(to: site_path(conn, :show, site))
      {:error, changeset} ->
        render(conn, "edit.html", site: site, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    site = Repo.get!(Site, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(site)

    conn
    |> put_flash(:info, "Site deleted successfully.")
    |> redirect(to: site_path(conn, :index))
  end
end
