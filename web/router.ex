defmodule Frezu.Router do
  use Frezu.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Frezu.Auth, repo: Frezu.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Frezu do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    # resources "/sites", SiteController
  end

  scope "/manage", Frezu do
    pipe_through [:browser, :authenticate_user]
    resources "/sites", SiteController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Frezu do
  #   pipe_through :api
  # end
end
