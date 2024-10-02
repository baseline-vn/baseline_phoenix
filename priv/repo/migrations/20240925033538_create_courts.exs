defmodule BaselinePhoenix.Repo.Migrations.CreateCourts do
  use Ecto.Migration

  def change do
    create table(:courts, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :facility_id, references(:facilities, type: :uuid, on_delete: :delete_all)
      add :identifier, :string
      add :surface_type, :string
      add :location_type, :string
      add :photo_data, :map

      timestamps(type: :utc_datetime)
    end

    index(:courts, [:facility_id])
    index(:courts, [:sport_type])
  end
end
