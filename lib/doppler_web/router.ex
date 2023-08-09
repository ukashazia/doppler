defmodule DopplerWeb.Router do
  use DopplerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DopplerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DopplerWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/servers", ServerController, :index
    get "/servers/search/page/:page", ServerController, :index
    get "/servers/search/:name/page/:page", ServerController, :index
    get "/servers/search/:name", ServerController, :index
    get "/servers/:name", ServerController, :show
  end

  scope "/", DopplerWeb do
    pipe_through :browser

    get "/servers/:name/users", UserController, :index
  end

  scope "/", DopplerWeb do
    pipe_through [:browser]

    post "/servers", ServerController, :index
    post "/servers/create", ServerController, :create
    post "/servers/delete/:server", ServerController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", DopplerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:doppler, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DopplerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
