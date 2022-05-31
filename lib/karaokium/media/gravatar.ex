defmodule Karaokium.Media.Gravatar do
  @moduledoc """
  A module to get the Gravatar of a user.
  """
  alias Karaokium.Accounts.User

  def picture(%User{email: email}) do
    hash =
      :crypto.hash(:md5, email)
      |> Base.encode16(case: :lower)

    "https://www.gravatar.com/avatar/#{hash}"
  end
end
