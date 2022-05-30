defmodule KaraokiumWeb.UserRegistrationControllerTest do
  use KaraokiumWeb.ConnCase

  import Karaokium.AccountsFixtures

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "Log in</a>"
      assert response =~ "Forgot your password?</a>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/karaokium"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      name = "José Valim"
      username = "josevalim#{System.unique_integer([:positive])}"

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => valid_user_attributes(name: name, username: username)
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/karaokium"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/karaokium")
      response = html_response(conn, 200)
      assert response =~ name
      assert response =~ username
      assert response =~ "Settings</a>"
      assert response =~ "Log out</a>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{"email" => "with spaces", "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
    end
  end
end
