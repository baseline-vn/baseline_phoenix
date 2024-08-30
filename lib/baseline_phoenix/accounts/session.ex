defmodule BaselinePhoenix.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "sessions" do
    field :user_agent, :string
    field :ip_address, :string
    field :expired_at, :naive_datetime_usec

    belongs_to :user, BaselinePhoenix.Accounts.User, type: Ecto.UUID
    belongs_to :api_token, BaselinePhoenix.Accounts.ApiToken, type: Ecto.UUID

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [
      :user_id,
      :user_agent,
      :ip_address,
      :api_token_id,
      :expired_at
    ])
    |> validate_required([:user_id])

    # |> assoc_constraint(:user)
    # |> assoc_constraint(:api_token)
  end
end
