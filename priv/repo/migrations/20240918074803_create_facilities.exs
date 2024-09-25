defmodule BaselinePhoenix.Repo.Migrations.CreateFacilities do
  use Ecto.Migration

  def change do
    create table(:facilities, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :address, :map
      add :description, :map
      add :name, :string
      add :photo_data, :map
      add :pic_email, :string
      add :pic_name, :string
      add :pic_phone, :string
      add :province, :string
      add :slug, :string
      add :status, :string
      add :url, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:facilities, [:slug])
  end
end
