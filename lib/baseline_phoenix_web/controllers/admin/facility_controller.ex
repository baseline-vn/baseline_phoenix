defmodule BaselinePhoenixWeb.Admin.FacilityController do
  use BaselinePhoenixWeb, :controller

  alias BaselinePhoenix.Facility

  def index(conn, %{"search" => search}) do
    {facilities, meta} = Facility.list_facility(search)
    render(conn, :index, facilities: facilities, search: search, meta: meta)
  end

  def index(conn, _params) do
    {facilities, meta} = Facility.list_facility()
    render(conn, :index, facilities: facilities, search: "", meta: meta)
  end

  def new(conn, _params) do
    changeset = Facility.changeset(%Facility{}, %{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"facility" => facility_params}) do
    case Facility.create_facility(facility_params) do
      {:ok, facility} ->
        conn
        |> put_flash(:info, "Facility created successfully.")
        |> redirect(to: ~p"/admin/facilities/#{facility}")

      {:error, %Ecto.Changeset{} = changeset} ->
        error_message =
          Enum.map_join(changeset.errors, ", ", fn {field, {message, _}} ->
            "#{Phoenix.Naming.humanize(field)} #{message}"
          end)

        conn
        |> put_flash(:error, "Failed to create facility: #{error_message}")
        |> render(:new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    facility = Facility.get_facility!(id)
    render(conn, :show, facility: facility)
  end

  def edit(conn, %{"id" => id}) do
    facility = Facility.get_facility!(id)
    changeset = Facility.change_facility!(facility)
    render(conn, :edit, facility: facility, changeset: changeset)
  end

  def update(conn, %{"id" => id, "facility" => facility_params}) do
    facility = Facility.get_facility!(id)

    case Facility.update_facility(facility, facility_params) do
      {:ok, facility} ->
        conn
        |> put_flash(:info, "Facility updated successfuly.")
        |> redirect(to: ~p"/admin/facilities/#{facility}")
    end
  end

  def delete(conn, %{"id" => id}) do
    facility = Facility.get_facility!(id)

    case Facility.delete_facilitiy(facility) do
      {:ok, _facility} ->
        conn
        |> put_flash(:info, "Facility deleted successfuly.")
        |> redirect(to: ~p"/admin/facilities")
    end
  end
end
