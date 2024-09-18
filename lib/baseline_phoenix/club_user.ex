defmodule BaselinePhoenix.ClubUser do
  use Ecto.Schema
  import Ecto.Changeset

  @roles ~w[member admin owner]
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "club_users" do
    field :role, :string

    belongs_to :user, BaselinePhoenix.User, type: Ecto.UUID
    belongs_to :club, BaselinePhoenix.Club, type: Ecto.UUID

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(club_user, attrs) do
    club_user
    |> cast(attrs, [:role, :user_id, :club_id])
    |> validate_required([:user_id, :club_id])
    |> validate_inclusion(:role, @roles)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:club_id)
    |> set_default_role()
  end

  defp set_default_role(changeset) do
    if get_field(changeset, :role) == nil do
      put_change(changeset, :role, "member")
    else
      changeset
    end
  end

  def roles, do: @roles
end
