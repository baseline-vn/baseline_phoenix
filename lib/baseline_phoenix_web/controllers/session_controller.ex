defmodule BaselinePhoenixWeb.SessionController do
  use BaselinePhoenixWeb, :controller
  alias BaselinePhoenix.UserManager
  alias BaselinePhoenix.UserManager.User
  alias BaselinePhoenix.UserManager.Guardian

  def new(conn, _) do
    changeset = BaselinePhoenix.UserManager.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: :protected)
    else
      render(conn, :new, layout: false, changeset: changeset, action: ~p"/sign_in")
    end
  end

  def sign_in(conn, %{"user" => %{"email" => email}}) do
    UserManager.authenticate_user(email)
    |> sign_in_reply(conn)
  end

  def logout(conn, _) do
    conn
    # This module's full name is Auth.UserManager.Guardian.Plug,
    |> Guardian.Plug.sign_out()
    # and the arguments specified in the Guardian.Plug.sign_out()
    |> redirect(to: "/sign_in")
  end

  # docs are not applicable here

  defp sign_in_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    # This module's full name is Auth.UserManager.Guardian.Plug,
    |> Guardian.Plug.sign_in(user)
    # and the arguments specified in the Guardian.Plug.sign_in()
    |> redirect(to: "/protected")
  end

  # docs are not applicable here.

  defp sign_in_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
