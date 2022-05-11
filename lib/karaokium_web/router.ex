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

    live_session :logged_in, on_mount: [{KaraokiumWeb.Hooks, :current_user}] do
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

      scope "/karaoke" do
        pipe_through [:require_authenticated_user]

        live "/:id", KaraokeLive.Show, :show
      end

      scope "/admin", Admin, as: :admin do
        pipe_through [:require_authenticated_user, :require_admin]

        scope "/repertoire" do
          live "/songs", SongLive.Index, :index
          live "/songs/new", SongLive.Index, :new
          live "/songs/search", SongLive.Search, :new
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

        scope "/groups" do
          scope "/teams" do
            live "/teams", TeamLive.Index, :index
            live "/teams/new", TeamLive.Index, :new
            live "/teams/:id/edit", TeamLive.Index, :edit

            live "/teams/:id", TeamLive.Show, :show
            live "/teams/:id/show/edit", TeamLive.Show, :edit
          end
        end
      end
    end

    scope "/sysadmin" do
      pipe_through [:require_authenticated_user, :require_sysadmin]

      live_dashboard "/dashboard",
        metrics: KaraokiumWeb.Telemetry,
        live_socket_path: "/karaokium/live"
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
