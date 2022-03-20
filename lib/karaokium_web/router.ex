defmodule KaraokiumWeb.Router do
  use KaraokiumWeb, :router

  import KaraokiumWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {KaraokiumWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KaraokiumWeb do
    pipe_through :browser

    get "/", PageController, :index

    scope "/repertoire" do
      live "/songs", SongLive.Index, :index
      live "/songs/new", SongLive.Index, :new
      live "/songs/:id/edit", SongLive.Index, :edit
      live "/songs/:id", SongLive.Show, :show
      live "/songs/:id/show/edit", SongLive.Show, :edit

      live "/artists", ArtistLive.Index, :index
      live "/artists/new", ArtistLive.Index, :new
      live "/artists/:id/edit", ArtistLive.Index, :edit
      live "/artists/:id", ArtistLive.Show, :show
      live "/artists/:id/show/edit", ArtistLive.Show, :edit

      live "/albums", AlbumLive.Index, :index
      live "/albums/new", AlbumLive.Index, :new
      live "/albums/:id/edit", AlbumLive.Index, :edit
      live "/albums/:id", AlbumLive.Show, :show
      live "/albums/:id/show/edit", AlbumLive.Show, :edit
    end

    scope "/events" do
      scope "/karaokes" do
        live "/", KaraokeLive.Index, :index
        live "/new", KaraokeLive.Index, :new
        live "/:id/edit", KaraokeLive.Index, :edit
        live "/:id", KaraokeLive.Show, :show
        live "/:id/show/edit", KaraokeLive.Show, :edit

        live "/:karaoke_id/performances", PerformanceLive.Index, :index
        live "/:karaoke_id/performances/new", PerformanceLive.Index, :new
        live "/:karaoke_id/performances/:id/edit", PerformanceLive.Index, :edit
        live "/:karaoke_id/performances/:id", PerformanceLive.Show, :show
        live "/:karaoke_id/performances/:id/show/edit", PerformanceLive.Show, :edit
      end

      live "/locations", LocationLive.Index, :index
      live "/locations/new", LocationLive.Index, :new
      live "/locations/:id/edit", LocationLive.Index, :edit
      live "/locations/:id", LocationLive.Show, :show
      live "/locations/:id/show/edit", LocationLive.Show, :edit
    end
  end

  scope "/polling" do
    live "/votes", VoteLive.Index, :index
    live "/votes/new", VoteLive.Index, :new
    live "/votes/:id/edit", VoteLive.Index, :edit
    live "/votes/:id", VoteLive.Show, :show
    live "/votes/:id/show/edit", VoteLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", KaraokiumWeb do
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

      live_dashboard "/dashboard", metrics: KaraokiumWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", KaraokiumWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", KaraokiumWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", KaraokiumWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
