defmodule BaselinePhoenixWeb.PageController do
  use BaselinePhoenixWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def protected(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "protected.html", current_user: user)
  end

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
