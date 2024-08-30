defmodule BaselinePhoenix.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :user_id, references(:users, type: :uuid, on_delete: :nothing), null: false
      add :user_agent, :string
      add :ip_address, :string
      add :api_token_id, references(:api_tokens, type: :uuid, on_delete: :nothing)
      add :expired_at, :naive_datetime_usec

      timestamps(type: :naive_datetime_usec)
    end

    create index(:sessions, [:api_token_id])
    create index(:sessions, [:user_id])
  end
end
