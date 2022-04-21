defmodule Karaokium.Repo.Seeds.Accounts do
  require Logger

  alias Karaokium.Repo

  alias Karaokium.Accounts.User

  def run do
    seed_users()
  end

  def seed_users do
    case Repo.all(User) do
      [] ->
        [
          %{
            name: "CeSIUM",
            username: "cesium",
            email: "cesium@di.uminho.pt",
            permissions: [:admin, :sysadmin],
            password: "Password1234!"
          },
          %{
            name: "CAOS",
            username: "caos",
            email: "caos@cesium.di.uminho.pt",
            permissions: [:sysadmin],
            password: "Password1234!"
          },
          %{
            name: "Recreativo",
            username: "recreativo",
            email: "recreativo@cesium.di.uminho.pt",
            permissions: [:admin],
            password: "Password1234!"
          }
        ]
        |> Enum.each(&insert_admin/1)

        # get_fake_users()
        # |> Enum.each(&insert_user/1)

      _ ->
        Mix.shell().error("Found users, aborting seeding admin users.")
    end
  end

  defp insert_admin(data) do
    %User{}
    |> User.admin_changeset(data)
    |> Repo.insert!()
  end

  defp insert_user(data) do
    %User{}
    |> User.registration_changeset(data)
    |> Repo.insert!()
  end

  defp get_fake_users(number \\ 20) do
    api_url = 'https://randomuser.me/api/?pagination=1&results=#{number}&seed=cesium'

    {:ok, {_title, _headers, data}} = :httpc.request(:get, {api_url, []}, [], [])

    %{"results" => results} = Jason.decode!(data)

    results
    |> Enum.map(&parse_fake_user/1)
  end

  defp parse_fake_user(%{
         "email" => email,
         "login" => %{"username" => username},
         "name" => %{"first" => first_name, "last" => last_name}
       }) do
    %{
      name: "#{first_name} #{last_name}",
      username: username,
      email: email,
      password: "Password1234!"
    }
  end
end

Karaokium.Repo.Seeds.Accounts.run()
