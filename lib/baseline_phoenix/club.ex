defmodule BaselinePhoenix.Club do
  import Ecto.Changeset
  import Ecto.Query, warn: false
  use Ecto.Schema

  alias BaselinePhoenix.Club
  alias BaselinePhoenix.Repo
  alias BaselinePhoenix.ClubUser

  @derive {
    Flop.Schema,
    filterable: [:name, :phone_number], sortable: [:name]
  }

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

    has_many :club_user, ClubUser, on_delete: :delete_all

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
    |> validate_required([:name, :email, :status])
    # Add this line for debugging
    |> validate_length(:email, max: 160)
    |> validate_length(:name, max: 160)
    |> validate_length(:address, max: 255)
    |> put_change(:slug, generate_slug(attrs["name"]))

    # Add this line for debugging
  end

  def verified_organizer(query \\ __MODULE__) do
    from c in query, where: c.verified_organizer == true
  end

  def approve!(%__MODULE__{} = record) do
    record
    |> Ecto.Changeset.change(status: :active, verified_organizer: true)
    |> BaselinePhoenix.Repo.update!()
  end

  def get_club!(id), do: Repo.get!(Club, id)

  def list_club(params) do
    Flop.validate_and_run(Club, params, for: Club)
  end

  def change_club!(%Club{} = club, attrs \\ %{}) do
    Club.changeset(club, attrs)
  end

  def create_club(attrs \\ %{}) do
    %Club{}
    |> Club.changeset(attrs)
    |> Repo.insert()
  end

  def update_club(%Club{} = club, attrs) do
    club
    |> Club.changeset(attrs)
    |> Repo.update()
  end

  def delete_club(%Club{} = club) do
    Repo.delete(club)
  end

  def generate_slug(name) do
    if is_binary(name) and byte_size(name) > 0 do
      name
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9\s-]/, "")
      |> String.replace(~r/[\s-]+/, "-")
      |> String.trim("-")
    else
      :crypto.strong_rand_bytes(8) |> Base.url_encode64(padding: false)
    end
  end
end
