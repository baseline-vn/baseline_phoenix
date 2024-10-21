defmodule BaselinePhoenixWeb.UserController do
  use BaselinePhoenixWeb, :controller
  alias BaselinePhoenix.Accounts

  def me(conn, _params) do
    user = conn.assigns.current_user
    render(conn, :profile, user: user)
  end

  def update_avatar(conn, %{"avatar" => avatar} = params) do
    user = conn.assigns.current_user

    case Accounts.update_user_avatar(user, params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Avatar updated successfully.")
        |> redirect(to: ~p"/me")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to update avatar.")
        |> redirect(to: ~p"/me")
    end
  end
end
