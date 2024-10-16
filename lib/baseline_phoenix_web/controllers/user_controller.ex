defmodule BaselinePhoenixWeb.UserController do
  use BaselinePhoenixWeb, :controller

  def profile(conn, _params) do
    render(conn, :profile)
  end
end
