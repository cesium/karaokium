defmodule Karaokium.Repo do
  use Ecto.Repo,
    otp_app: :karaokium,
    adapter: Ecto.Adapters.SQLite3
end
