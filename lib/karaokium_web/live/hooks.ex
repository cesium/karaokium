defmodule KaraokiumWeb.Hooks do
  @moduledoc """
  Ensures common `assigns` are applied to all LiveViews attaching this hook.
  """
  import Phoenix.LiveView

  alias Karaokium.Accounts

  def on_mount(:default, _params, _session, socket) do
    {:cont, socket}
  end

  def on_mount(:current_user, _params, %{"user_token" => user_token}, socket) do
    {:cont, assign(socket, current_user: Accounts.get_user_by_session_token(user_token))}
  end
end
