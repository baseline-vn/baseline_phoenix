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
    get "/dashboard", DashboardController, :index
    get "/rankings", DashboardController, :rankings
    get "/clubs", DashboardController, :clubs
    get "/tournaments", DashboardController, :tournaments
    get "/me", UserController, :me
    post "/users/update_avatar", UserController, :update_avatar
  end

  scope "/" do
    storybook_assets()
  end

  scope "/", BaselinePhoenixWeb do
    pipe_through(:browser)
    live_storybook("/storybook", backend_module: BaselinePhoenixWeb.Storybook)
  end

  # Other scopes may use custom stacks.
  # scope "/api", BaselinePhoenixWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:baseline_phoenix, :dev_routes) do
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

    resources "/profile", UserController, only: [:show], singleton: true
  end

  scope "/", BaselinePhoenixWeb do
    pipe_through [:browser]

    delete "/log_out", UserSessionController, :delete
  end

  ## Admin routes
  scope "/admin", BaselinePhoenixWeb.Admin, as: :admin do
    pipe_through [:browser, :admin]

    resources "/dashboard", DashboardController, only: [:index]
    resources "/clubs", ClubController
    resources "/matches", MatchController, only: [:index]
    resources "/tournaments", TournamentController, only: [:index]

    resources "/facilities", FacilityController do
      resources "/courts", CourtController
    end

    resources "/recording_devices", RecordingDeviceController, only: [:index]
    resources "/feedback", FeedbackController, only: [:index]
    resources "/articles", ArticleController, only: [:index]
    resources "/changelog", ChangelogController, only: [:index]
    resources "/campaigns", CampaignController, only: [:index]

    resources "/users", UserController do
      get "/merge", UserController, :merge
      get "/imports", UserController, :imports
      get "/potential_dupes", UserController, :potential_dupes
    end
  end
end
