defmodule BaselinePhoenix.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BaselinePhoenix.Repo

  alias BaselinePhoenix.Accounts.{User, Session}

  ## Database getters

  @doc """
  Gets a user by phone_number.

  ## Examples

      iex> get_user_by_phone_number("foo@example.com")
      %User{}

      iex> get_user_by_phone_number("unknown@example.com")
      nil

  """
  def get_user_by_phone_number(phone_number) do
    case Repo.get_by(User, phone_number: phone_number) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def get_or_insert_user_by_phone_number(phone_number) do
    case Repo.get_by(User, phone_number: phone_number) do
      nil ->
        %User{}
        |> User.sign_in_changeset(%{phone_number: phone_number})
        |> Repo.insert()
        |> case do
          {:ok, user} -> {:ok, user}
          {:error, changeset} -> {:error, changeset}
        end

      user ->
        {:ok, user}
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  ## User registration

  ## Session
  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = Session.verify_session_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(Session.by_session_id_query(token))
    :ok
  end

  def create_session_for_user(user, ip_address, user_agent) do
    session =
      %Session{}
      |> Session.changeset(%{
        user_id: user.id,
        ip_address: ip_address,
        user_agent: user_agent
      })
      |> Repo.insert!()

    session.id
  end

  @doc """
  Returns the list of users.
  """
  def list_users(search \\ nil) do
    query = from(u in User)

    # Apply filtering if a search term is provided
    query =
      if search && search != "" do
        from u in query,
          where: ilike(u.full_name, ^"%#{search}%") or ilike(u.phone_number, ^"%#{search}%")
      else
        query
      end

    # Get the total count and paginate
    total_count = Repo.aggregate(query, :count, :id)
    users = query |> limit(10) |> Repo.all()

    # Calculate pagination metadata
    # Adjust this based on your pagination logic
    current_page = 1
    # Assuming 10 users per page
    total_pages = div(total_count + 9, 10)
    next_page = if current_page < total_pages, do: current_page + 1, else: nil

    # Create meta information
    meta = %{
      total_count: total_count,
      total_pages: total_pages,
      current_page: current_page,
      has_next_page?: current_page < total_pages,
      has_previous_page?: current_page > 1,
      # Add next_page to the meta
      next_page: next_page
    }

    {users, meta}
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
