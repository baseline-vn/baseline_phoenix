defmodule BaselinePhoenixWeb.Router do
  use BaselinePhoenixWeb, :router

  import BaselinePhoenixWeb.UserAuth
  import PhoenixStorybook.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BaselinePhoenixWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug :require_authenticated_user
    plug :require_admin_user
    plug :put_layout, html: {BaselinePhoenixWeb.Layouts, :admin}
  end

  pipeline :dashboard do
    plug :put_layout, html: {BaselinePhoenixWeb.Layouts, :dashboard}
  end

  scope "/", BaselinePhoenixWeb do
    pipe_through [:browser, :dashboard]

    get "/", DashboardController, :index
  end

  scope "/" do
    storybook_assets()
  end

  scope "/", Elixir.BaselinePhoenixWeb do
    pipe_through(:browser)
    live_storybook("/storybook", backend_module: Elixir.BaselinePhoenixWeb.Storybook)
  end

  # Other scopes may use custom stacks.
  # scope "/api", BaselinePhoenixWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:baseline_phoenix, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BaselinePhoenixWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", BaselinePhoenixWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/sign_in", UserSessionController, :new
    post "/sign_in", UserSessionController, :create
  end

  scope "/", BaselinePhoenixWeb do
    pipe_through [:browser, :require_authenticated_user]
  end

  scope "/", BaselinePhoenixWeb do
    pipe_through [:browser]

    delete "/log_out", UserSessionController, :delete
  end

  ## Admin routes
  scope "/admin", BaselinePhoenixWeb.Admin, as: :admin do
    pipe_through [:browser, :admin]

    get "/dashboard", DashboardController, :index
    resources "/clubs", ClubController
    get "/matches", MatchController, :index
    get "/tournaments", TournamentController, :index
    get "/facilities", FacilityController, :index
    get "/recording_devices", RecordingDeviceController, :index
    get "/feedback", FeedbackController, :index
    get "/articles", ArticleController, :index
    get "/changelog", ChangelogController, :index
    get "/campaigns", CampaignController, :index
    resources "/users", UserController
    get "/users/merge", UserController, :merge
    get "/users/imports", UserController, :imports
    get "/users/potential_dupes", UserController, :potential_dupes
  end
end
