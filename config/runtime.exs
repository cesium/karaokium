import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.

if config_env() in [:dev, :test] do
  import Dotenvy
  source([".env", ".env.#{config_env()}", ".env.#{config_env()}.local"])

  database_path =
    "../priv/repo/databases/karaokium_#{config_env()}.db"
    |> Path.expand(Path.dirname(__ENV__.file))

  config :karaokium, Karaokium.Repo, database: env!("DATABASE_PATH", :string, database_path)

  if config_env() == :dev do
    config :karaokium, Karaokium.Spotify,
      client_id: env!("SPOTIFY_CLIENT_ID"),
      client_secret: env!("SPOTIFY_CLIENT_SECRET")
  end
end

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/yearbook start
#
# Start the phoenix server if environment is set and running in a release
if System.get_env("PHX_SERVER") do
  config :karaokium, KaraokiumWeb.Endpoint, server: true
end

# The block below contains prod specific runtime configuration.
if config_env() in [:stg, :prod] do
  spotify_client_id =
    System.get_env("SPOTIFY_CLIENT_ID") ||
      raise """
      environment variable SPOTIFY_CLIENT_ID is missing.
      Go to https://developer.spotify.com/dashboard/applications get one.
      """

  spotify_client_secret =
    System.get_env("SPOTIFY_CLIENT_SECRET") ||
      raise """
      environment variable SPOTIFY_CLIENT_SECRET is missing.
      Go to https://developer.spotify.com/dashboard/applications get one.
      """

  config :karaokium, Karaokium.Spotify,
    client_id: spotify_client_id,
    client_secret: spotify_client_secret

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "cesium.di.uminho.pt"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :karaokium, KaraokiumWeb.Endpoint,
    url: [host: host],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base
end

if config_env() == :prod do
  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  sendinblue_api_key =
    System.get_env("SENDINBLUE_API_KEY") ||
      raise """
      environment variable SENDINBLUE_API_KEY is missing.
      """

  # Swoosh API client is needed for adapters other than SMTP.
  config :swoosh, :api_client, Swoosh.ApiClient.Hackney

  config :karaokium, Karaokium.Mailer,
    adapter: Swoosh.Adapters.Sendinblue,
    api_key: sendinblue_api_key

  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
end
