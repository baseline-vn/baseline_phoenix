defmodule BaselinePhoenixWeb.Admin.ClubController do
  # credo:disable-for-next-line
  use BaselinePhoenixWeb, :controller

  alias BaselinePhoenix.Club
  alias BaselinePhoenix.Repo
  alias BaselinePhoenix.ClubUser

  def index(conn, %{"search" => search}) do
    {clubs, meta} = Club.list_club(search)
    render(conn, :index, clubs: clubs, search: search, meta: meta)
  end

  def index(conn, _params) do
    {clubs, meta} = Club.list_club()
    render(conn, :index, clubs: clubs, search: "", meta: meta)
  end

  def new(conn, _params) do
    changeset = Club.changeset(%Club{}, %{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"club" => club_params}) do
    user_id = conn.assigns.current_user.id

    case Club.create_club(club_params) do
      {:ok, club} ->
        ClubUser.changeset(%ClubUser{}, %{user_id: user_id, club_id: club.id})
        |> Repo.insert()

        conn
        |> put_flash(:info, "Club created successfully.")
        |> redirect(to: ~p"/admin/clubs/#{club}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    club = Club.get_club!(id)
    render(conn, :show, club: club)
  end

  def edit(conn, %{"id" => id}) do
    club = Club.get_club!(id)
    changeset = Club.change_club!(club)
    render(conn, :edit, club: club, changeset: changeset)
  end

  def update(conn, %{"id" => id, "club" => club_params}) do
    club = Club.get_club!(id)

    case Club.update_club(club, club_params) do
      {:ok, club} ->
        conn
        |> put_flash(:info, "Club updated successfuly.")
        |> redirect(to: ~p"/admin/clubs/#{club}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, club: club, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    # id = Ecto.UUID.caspt!(id)
    club = Club.get_club!(id)

    case Club.delete_club(club) do
      {:ok, _club} ->
        conn
        |> put_flash(:info, "Club deleted successfuly.")
        |> redirect(to: ~p"/admin/clubs")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to delete club.")
        |> redirect(to: ~p"/admin/clubs")
    end
  end
end
