defmodule BaselinePhoenix.Facility do
  import Ecto.Changeset
  use Ecto.Schema

  alias BaselinePhoenix.Facility
  alias BaselinePhoenix.Repo

  @derive {
    Flop.Schema,
    filterable: [:name], sortable: [:name]
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "facilities" do
    field :address, :map
    field :description, :map
    field :name, :string
    field :photo_data, :map
    field :pic_email, :string
    field :pic_phone, :string
    field :pic_name, :string
    field :province, :string
    field :slug, :string
    field :status, Ecto.Enum, values: [:draft, :review, :active, :archived], default: :draft
    field :url, :string

    timestamps(type: :utc_datetime)
    has_many :courts, BaselinePhoenix.Court, on_delete: :delete_all
  end

  def changeset(facility, attrs) do
    facility
    |> cast(attrs, [
      :address,
      :description,
      :name,
      :photo_data,
      :pic_email,
      :pic_phone,
      :pic_name,
      :province,
      :slug,
      :status,
      :url
    ])
    |> validate_required([:name, :status])
    # Add this line for debugging
    |> validate_length(:name, max: 160)
    |> validate_length(:address, max: 255)
    |> put_change(:slug, generate_slug(attrs["name"]))
  end

  def get_facility!(id), do: Repo.get!(Facility, id)

  def list_facility(params) do
    Flop.validate_and_run(Facility, params, for: Facility)
  end

  def change_facility!(%Facility{} = facility, attrs \\ %{}) do
    Facility.changeset(facility, attrs)
  end

  def create_facility(attrs \\ %{}) do
    %Facility{}
    |> Facility.changeset(attrs)
    |> Repo.insert()
  end

  def update_facility(%Facility{} = facility, attrs) do
    facility
    |> Facility.changeset(attrs)
    |> Repo.update()
  end

  def delete_facilitiy(%Facility{} = facility) do
    Repo.delete(facility)
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
