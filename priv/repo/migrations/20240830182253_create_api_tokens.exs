defmodule BaselinePhoenix.Repo.Migrations.CreateApiTokens do
  use Ecto.Migration

  def change do
    create table(:api_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :user_id, references(:users, type: :uuid, on_delete: :nothing), null: false
      add :token, :string
      add :name, :string
      add :metadata, :map, default: %{}
      add :transient, :boolean, default: false
      add :last_used_at, :naive_datetime_usec
      add :expires_at, :naive_datetime_usec

      timestamps(type: :naive_datetime_usec)
    end

    create unique_index(:api_tokens, [:token])
    create index(:api_tokens, [:user_id])
  end
end
