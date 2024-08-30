defmodule BaselinePhoenix.Accounts.ApiToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "api_tokens" do
    field :token, :string
    field :name, :string
    field :metadata, :map, default: %{}
    field :transient, :boolean, default: false
    field :last_used_at, :naive_datetime_usec
    field :expires_at, :naive_datetime_usec

    belongs_to :user, BaselinePhoenix.Accounts.User, type: Ecto.UUID

    timestamps(type: :naive_datetime_usec)
  end

  @doc false
  def changeset(api_token, attrs) do
    api_token
    |> cast(attrs, [
      :user_id,
      :token,
      :name,
      :metadata,
      :transient,
      :last_used_at,
      :expires_at,
      :created_at,
      :updated_at
    ])
    |> validate_required([:user_id, :token, :created_at, :updated_at])
    |> unique_constraint(:token, name: :index_api_tokens_on_token)
    |> assoc_constraint(:user)
  end
end
