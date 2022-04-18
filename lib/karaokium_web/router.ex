defmodule KaraokiumWeb.Router do
  use KaraokiumWeb, :router

  import Phoenix.LiveDashboard.Router
  import KaraokiumWeb.Plugs.Auth

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

  scope "/karaokium/api", KaraokiumWeb do
    pipe_through :api

    get "/", PageController, :about
  end

  get "/", KaraokiumWeb.PageController, :goto

  scope "/karaokium", KaraokiumWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/_version", PageController, :version

    scope "/auth" do
      scope "/accounts" do
        pipe_through [:redirect_if_user_is_authenticated]
        get "/register", UserRegistrationController, :new
        post "/register", UserRegistrationController, :create
        get "/log_in", UserSessionController, :new
        post "/log_in", UserSessionController, :create
        get "/reset_password", UserResetPasswordController, :new
        post "/reset_password", UserResetPasswordController, :create
        get "/reset_password/:token", UserResetPasswordController, :edit
        put "/reset_password/:token", UserResetPasswordController, :update
      end

      scope "/accounts" do
        pipe_through [:require_authenticated_user]
        get "/settings", UserSettingsController, :edit
        put "/settings", UserSettingsController, :update
        get "/settings/confirm_email/:token", UserSettingsController, :confirm_email
      end

      scope "/accounts" do
        delete "/log_out", UserSessionController, :delete
        get "/confirm", UserConfirmationController, :new
        post "/confirm", UserConfirmationController, :create
        get "/confirm/:token", UserConfirmationController, :edit
        post "/confirm/:token", UserConfirmationController, :update
      end
    end

    scope "/admin" do
      pipe_through [:require_authenticated_user, :require_admin]

      scope "/repertoire" do
        live "/songs", AdminSongLive.Index, :index
        live "/songs/new", AdminSongLive.Index, :new
        live "/songs/:id/edit", AdminSongLive.Index, :edit
        live "/songs/:id", AdminSongLive.Show, :show
        live "/songs/:id/show/edit", AdminSongLive.Show, :edit

        live "/artists", AdminArtistLive.Index, :index
        live "/artists/new", AdminArtistLive.Index, :new
        live "/artists/:id/edit", AdminArtistLive.Index, :edit
        live "/artists/:id", AdminArtistLive.Show, :show
        live "/artists/:id/show/edit", AdminArtistLive.Show, :edit

        live "/albums", AdminAlbumLive.Index, :index
        live "/albums/new", AdminAlbumLive.Index, :new
        live "/albums/:id/edit", AdminAlbumLive.Index, :edit
        live "/albums/:id", AdminAlbumLive.Show, :show
        live "/albums/:id/show/edit", AdminAlbumLive.Show, :edit
      end

      scope "/events" do
        scope "/karaokes" do
          live "/", AdminKaraokeLive.Index, :index
          live "/new", AdminKaraokeLive.Index, :new
          live "/:id/edit", AdminKaraokeLive.Index, :edit
          live "/:id", AdminKaraokeLive.Show, :show
          live "/:id/show/edit", AdminKaraokeLive.Show, :edit

          live "/:karaoke_id/performances", AdminPerformanceLive.Index, :index
          live "/:karaoke_id/performances/new", AdminPerformanceLive.Index, :new
          live "/:karaoke_id/performances/:id/edit", AdminPerformanceLive.Index, :edit
          live "/:karaoke_id/performances/:id", AdminPerformanceLive.Show, :show
          live "/:karaoke_id/performances/:id/show/edit", AdminPerformanceLive.Show, :edit
        end

        live "/locations", AdminLocationLive.Index, :index
        live "/locations/new", AdminLocationLive.Index, :new
        live "/locations/:id/edit", AdminLocationLive.Index, :edit
        live "/locations/:id", AdminLocationLive.Show, :show
        live "/locations/:id/show/edit", AdminLocationLive.Show, :edit
      end
    end

    scope "/sysadmin" do
      pipe_through [:require_authenticated_user, :require_sysadmin]

      live_dashboard "/dashboard",
        metrics: KaraokiumWeb.Telemetry,
        live_socket_path: "/karaokium/live"
    end

    scope "/polling" do
      live "/votes", VoteLive.Index, :index
      live "/votes/new", VoteLive.Index, :new
      live "/votes/:id/edit", VoteLive.Index, :edit
      live "/votes/:id", VoteLive.Show, :show
      live "/votes/:id/show/edit", VoteLive.Show, :edit
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
end
