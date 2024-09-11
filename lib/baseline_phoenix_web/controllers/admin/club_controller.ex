defmodule BaselinePhoenixWeb.Admin.ClubController do
  use BaselinePhoenixWeb, :controller

  alias BaselinePhoenix.Club
  alias BaselinePhoenix.Repo

  def index(conn, _params) do
    clubs = Repo.all(Club)
    render(conn, :index, clubs: clubs)
  end
end
