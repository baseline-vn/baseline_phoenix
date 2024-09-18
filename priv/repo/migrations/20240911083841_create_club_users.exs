defmodule BaselinePhoenix.Repo.Migrations.CreateClubUsers do
  use Ecto.Migration

  def change do
    create table(:club_users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :role, :string
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing), null: false
      add :club_id, references(:clubs, type: :binary_id, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:club_users, [:user_id])
    create index(:club_users, [:club_id])
    create unique_index(:club_users, [:user_id, :club_id])
  end
end
