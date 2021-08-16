defmodule TractionWeb.Router do
  use TractionWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TractionWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TractionWeb do
    pipe_through :browser
    live "/", GuildLive.Index, :index
    live "/new", GuildLive.Index, :index

    live "/guilds", GuildLive.Index, :index
    live "/guilds/new", GuildLive.Index, :new
    live "/guilds/:id/edit", GuildLive.Index, :edit

    live "/guilds/:id", GuildLive.Show, :show
    live "/guilds/:id/show/edit", GuildLive.Show, :edit

    live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TractionWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TractionWeb.Telemetry
    end
  end
end
