defmodule BaselinePhoenix.Accounts.Session do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias BaselinePhoenix.Accounts.Session

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

  def verify_session_token_query(session_id) do
    query =
      from session in by_token_and_context_query(session_id),
        join: user in assoc(session, :user),
        select: user

    {:ok, query}
  end

  def by_token_and_context_query(session_id) do
    from Session, where: [id: ^session_id]
  end
end
