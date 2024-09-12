defmodule BaselinePhoenixWeb.Admin.ClubController do
  # credo:disable-for-next-line
  use BaselinePhoenixWeb, :controller

  alias BaselinePhoenix.Club
  alias BaselinePhoenix.Repo

  def index(conn, _params) do
    clubs = Repo.all(Club)
    render(conn, :index, clubs: clubs)
  end

  def show(conn, %{"id" => id}) do
    club = Repo.get(Club, id)
    render(conn, :show, club: club)
  end

  def new(conn, _params) do
    changeset = Club.changeset(%Club{}, %{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"club" => club_params}) do
    case Club.create_club(club_params) do
      {:ok, club} ->
        conn
        |> put_flash(:info, "Club created successfully.")
        |> redirect(to: ~p"/admin/clubs/#{club}")

      {:error, %Ecto.Changeset{} = changeset} ->
        error_message =
          Enum.map_join(changeset.errors, ", ", fn {field, {message, _}} ->
            "#{Phoenix.Naming.humanize(field)} #{message}"
          end)

        conn
        |> put_flash(:error, "Failed to create user: #{error_message}")
        |> render(:new, changeset: changeset)
    end
  end
end
