defmodule BaselinePhoenix.Repo.Migrations.CreateClubs do
  use Ecto.Migration

  def change do
    create table(:clubs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :about, :map
      add :address, :string
      add :cover_data, :string
      add :email, :string
      add :logo_data, :map
      add :name, :string, null: false
      add :phone_number, :string
      add :since, :date
      add :slug, :string, null: false
      add :status, :string
      add :verified_organizer, :boolean, default: false, null: false
      add :website, :string

      timestamps(type: :utc_datetime)
    end
  end
end
