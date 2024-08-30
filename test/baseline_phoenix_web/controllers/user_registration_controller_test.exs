defmodule BaselinePhoenixWeb.UserRegistrationControllerTest do
  use BaselinePhoenixWeb.ConnCase, async: true

  import BaselinePhoenix.AccountsFixtures

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, ~p"/register")
      response = html_response(conn, 200)
      assert response =~ "Register"
      assert response =~ ~p"/sign_in"
      assert response =~ ~p"/register"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> sign_in_user(user_fixture()) |> get(~p"/register")

      assert redirected_to(conn) == ~p"/"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, ~p"/register", %{
          "user" => valid_user_attributes(email: email)
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ ~p"/settings"
      assert response =~ ~p"/log_out"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, ~p"/register", %{
          "user" => %{"email" => "with spaces", "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ "Register"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
    end
  end
end
