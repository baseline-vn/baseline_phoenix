defmodule BaselinePhoenix.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :email, :string
    field :phone_number, :string
    field :full_name, :string
    field :webauthn_id, :string
    field :confirmed_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  defp validate_phone_number(changeset, opts) do
    changeset
    |> validate_required([:phone_number])
    |> maybe_validate_unique_phone_number(opts)
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

  defp generate_webauthn_id(changeset) do
    if get_field(changeset, :webauthn_id) do
      changeset
    else
      webauthn_id = :crypto.strong_rand_bytes(64) |> Base.encode64()
      put_change(changeset, :webauthn_id, webauthn_id)
    end
  end
end
