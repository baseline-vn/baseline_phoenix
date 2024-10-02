defmodule BaselinePhoenixWeb.Admin.CourtController do
  use BaselinePhoenixWeb, :controller

  alias BaselinePhoenix.Facility
  alias BaselinePhoenix.Court

  plug :set_facility when action in [:new, :show, :create, :edit, :update, :index]

  def index(conn, _params) do
    facility_id = conn.params["facility_id"]
    courts = Court.get_court_by_facility_id(facility_id)
    render(conn, :index, courts: courts)
  end

  def new(conn, _params) do
    changeset = Court.changeset(%Court{}, %{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"court" => court_params}) do
    facility_id = conn.params["facility_id"]
    updated_court_params = Map.put(court_params, "facility_id", facility_id)

    case Court.create_court(updated_court_params) do
      {:ok, court} ->
        conn
        |> put_flash(:info, "Court created successfully.")
        |> redirect(to: ~p"/admin/facilities/#{facility_id}/courts")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    court = Court.get_court(id)
    render(conn, :show, court: court)
  end

  def edit(conn, %{"id" => id}) do
    court = Court.get_court(id)
    changeset = Court.change_court!(court)
    render(conn, :edit, court: court, changeset: changeset)
  end

  def update(conn, %{"id" => id, "court" => court_params}) do
    facility_id = conn.params["facility_id"]

    court = Court.get_court(id)

    case Court.update_court!(court, court_params) do
      {:ok, court} ->
        conn
        |> put_flash(:info, "Court updated successfully.")
        |> redirect(to: ~p"/admin/facilities/#{facility_id}/courts")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, court: court, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    facility_id = conn.params["facility_id"]

    court = Court.get_court(id)
    {:ok, _court} = Court.delete_court!(court)

    conn
    |> put_flash(:info, "Court deleted successfully.")
    |> redirect(to: ~p"/admin/facilities/#{facility_id}/courts")
  end

  defp set_facility(conn, _params) do
    facility = Facility.get_facility!(conn.params["facility_id"])
    assign(conn, :facility, facility)
  end
end
