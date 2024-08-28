defmodule BaselinePhoenix.UserManager.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias BaselinePhoenix.UserManager.User

  schema "users" do
    field :email, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email])
  end
end
