defmodule BaselinePhoenix.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :vtid, :string
      add :email, :string
      add :full_name, :string
      add :gender, :string
      add :email, :string
      add :province, :string
      add :city, :string
      add :date_of_birth, :date
      add :onboarded, :boolean, default: false, null: false
      add :admin, :boolean, default: false, null: false
      add :verified, :boolean, default: false, null: false
      add :webauthn_id, :string, null: false
      add :avatar_data, :map
      add :yrs_experience, :integer
      add :declared_rank, :integer
      add :played_tournaments, :boolean
      add :referral_points, :integer
      add :referral_token, :string
      add :referrer_id, :uuid
      add :cover_data, :map
      add :court_position, :string
      add :best_hand, :string
      add :duplicate_risk, :boolean, default: false
      add :classic_rank_topic_id, :string
      add :modern_rank_topic_id, :string
      add :classic_rank, :integer
      add :modern_rank, :decimal, precision: 5, scale: 4

      add :bio, :text
      add :deletion_request_at, :utc_datetime_usec
      add :discarded_at, :utc_datetime_usec
      add :slug, :string
      add :nickname, :string
      add :deactivated_at, :utc_datetime_usec
      add :last_active_at, :utc_datetime_usec

      timestamps()
    end

    create constraint(:users, :modern_rank_range_check,
             check: "modern_rank >= 1.0000 AND modern_rank <= 6.9999"
           )
  end
end
