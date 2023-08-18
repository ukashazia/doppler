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
    live "/servers", ServerLive
    live "/servers/create", Live.ServerForm.ServerFormLive
    live "/servers/search/:name", ServerLive
    live "/servers/:name/info", ServerShowLive, :server_info
    live "/servers/:name/posts", ServerShowLive, :server_posts
    live "/servers/:name", ServerShowLive, :redirect
  end

  scope "/", DopplerWeb do
    pipe_through :browser
    live "/servers/:name/users", ServerShowLive, :server_users
    live "/servers/:name/users/create", Live.ServerUsers.UserFormLive
    live "/servers/:name/users/:username/info", Live.ServerUsers.ServerUserShowLive, :user_info
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
