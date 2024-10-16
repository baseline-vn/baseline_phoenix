defmodule BaselinePhoenixWeb.UserController do
  use BaselinePhoenixWeb, :controller

  def me(conn, _params) do
    user = conn.assigns.current_user
    render(conn, :profile, user: user)
  end
end
