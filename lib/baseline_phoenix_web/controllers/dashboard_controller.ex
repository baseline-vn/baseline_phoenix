defmodule BaselinePhoenixWeb.DashboardController do
  use BaselinePhoenixWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end

  def rankings(conn, _params) do
    render(conn, :rankings)
  end

  def clubs(conn, _params) do
    render(conn, :clubs)
  end

  def tournaments(conn, _params) do
    render(conn, :tournaments)
  end
end
