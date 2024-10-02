defmodule BaselinePhoenix.Court do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias BaselinePhoenix.Court
  alias BaselinePhoenix.Repo

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "courts" do
    field :identifier, :string
    field :location_type, :string
    field :photo_data, :map
    field :surface_type, :string

    belongs_to :facility, BaselinePhoenix.Facility, type: Ecto.UUID

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(court, attrs) do
    court
    |> cast(attrs, [:identifier, :location_type, :photo_data, :surface_type, :facility_id])
    |> validate_required([:identifier, :location_type, :surface_type])
  end

  def get_court_by_facility_id(facility_id) do
    from(c in Court, where: c.facility_id == ^facility_id)
    |> Repo.all()
  end

  def change_court!(%Court{} = court, attrs \\ %{}) do
    Court.changeset(court, attrs)
  end

  def create_court(attrs \\ %{}) do
    %Court{}
    |> Court.changeset(attrs)
    |> Repo.insert()
  end

  def get_court(id) do
    Repo.get!(Court, id)
  end

  def update_court!(%Court{} = court, attrs \\ %{}) do
    Court.changeset(court, attrs)
    |> Repo.update()
  end

  def delete_court!(%Court{} = court) do
    Repo.delete(court)
  end
end
