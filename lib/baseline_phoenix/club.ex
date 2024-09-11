defmodule BaselinePhoenix.Club do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "clubs" do
    field :about, :map
    field :address, :string
    field :cover_data, :string
    field :email, :string
    field :logo_data, :map
    field :name, :string
    field :phone_number, :string
    field :since, :date
    field :slug, :string
    field :status, Ecto.Enum, values: [:draft, :review, :active, :archived], default: :draft
    field :verified_organizer, :boolean, default: false
    field :website, :string

    has_many :club_user, BaselinePhoenix.ClubUser, on_delete: :delete_all
    has_many :user, BaselinePhoenix.Accounts.User, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  def changeset(club, attrs) do
    club
    |> cast(attrs, [
      :name,
      :about,
      :address,
      :email,
      :phone_number,
      :since,
      :slug,
      :status,
      :verified_organizer,
      :website
    ])
    |> validate_required([:name, :email, :slug, :status])
    # |> validate_format(:email, ~r/^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> validate_length(:name, max: 160)
    |> validate_length(:address, max: 255)
    |> unique_constraint(:slug)
  end

  def verified_organizer(query \\ __MODULE__) do
    from c in query, where: c.verified_organizer == true
  end

  def approve!(%__MODULE__{} = record) do
    record
    |> Ecto.Changeset.change(status: :active, verified_organizer: true)
    |> BaselinePhoenix.Repo.update!()
  end
end
