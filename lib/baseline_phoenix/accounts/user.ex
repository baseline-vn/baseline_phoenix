defmodule BaselinePhoenix.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  use Waffle.Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :email, :string
    field :confirmed_at, :utc_datetime
    field :vtid, :string
    field :full_name, :string
    field :gender, :string
    field :phone_number, :string
    field :province, :string
    field :avatar, :string
    field :city, :string
    field :date_of_birth, :date
    field :onboarded, :boolean, default: false
    field :admin, :boolean, default: false
    field :verified, :boolean, default: false
    field :webauthn_id, :string
    field :avatar_data, :map
    field :yrs_experience, :integer
    field :declared_rank, :integer
    field :played_tournaments, :boolean
    field :referral_points, :integer
    field :referral_token, :string
    field :referrer_id, :binary_id
    field :cover_data, :map
    field :court_position, :string
    field :best_hand, :string
    field :duplicate_risk, :boolean, default: false
    field :classic_rank_topic_id, :string
    field :modern_rank_topic_id, :string
    field :classic_rank, :integer
    field :modern_rank, :decimal
    field :bio, :string
    field :deletion_request_at, :utc_datetime
    field :discarded_at, :utc_datetime
    field :slug, :string
    field :nickname, :string
    field :deactivated_at, :utc_datetime
    field :last_active_at, :utc_datetime

    has_many :sessions, BaselinePhoenix.Accounts.Session, on_delete: :delete_all
    has_many :club_user, BaselinePhoenix.ClubUser, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  defp validate_phone_number(changeset, opts) do
    changeset
    |> validate_required([:phone_number])
    |> maybe_validate_unique_phone_number(opts)
  end

  def changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [
      :email,
      :confirmed_at,
      :vtid,
      :full_name,
      :gender,
      :phone_number,
      :province,
      :city,
      :date_of_birth,
      :onboarded,
      :admin,
      :verified,
      :webauthn_id,
      :avatar_data,
      :yrs_experience,
      :declared_rank,
      :played_tournaments,
      :referral_points,
      :referral_token,
      :referrer_id,
      :cover_data,
      :court_position,
      :best_hand,
      :duplicate_risk,
      :classic_rank_topic_id,
      :modern_rank_topic_id,
      :classic_rank,
      :modern_rank,
      :bio,
      :deletion_request_at,
      :discarded_at,
      :slug,
      :nickname,
      :deactivated_at,
      :last_active_at
    ])
    |> generate_webauthn_id()
    |> validate_required([:phone_number, :full_name])
    |> validate_phone_number(opts)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, BaselinePhoenix.Repo)
    |> unique_constraint(:email)
    |> validate_length(:full_name, max: 255)
    |> validate_length(:province, max: 255)
    |> unique_constraint(:nickname)
  end

  def sign_in_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:phone_number, :webauthn_id])
    |> generate_webauthn_id
    |> validate_phone_number(opts)
  end

  defp maybe_validate_unique_phone_number(changeset, opts) do
    if Keyword.get(opts, :validate_phone_number, true) do
      changeset
      |> unsafe_validate_unique(:phone_number, BaselinePhoenix.Repo)
      |> unique_constraint(:phone_number)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the phone_number.

  It requires the phone_number to change otherwise an error is added.
  """
  def phone_number_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:phone_number])
    |> validate_phone_number(opts)
    |> case do
      %{changes: %{phone_number: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :phone_number, "did not change")
    end
  end

  def avatar_changeset(user, attrs) do
    user
    |> cast(attrs, [:avatar])
  end

  defp generate_webauthn_id(changeset) do
    if get_field(changeset, :webauthn_id) do
      changeset
    else
      webauthn_id = :crypto.strong_rand_bytes(64) |> Base.encode64()
      put_change(changeset, :webauthn_id, webauthn_id)
    end
  end
end
