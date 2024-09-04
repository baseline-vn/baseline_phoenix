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
    Repo.get_by(User, phone_number: phone_number)
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
  Gets a user by phone_number and password.

  ## Examples

      iex> get_user_by_phone_number_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_phone_number_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_phone_number_and_password(phone_number, password)
      when is_binary(phone_number) and is_binary(password) do
    user = Repo.get_by(User, phone_number: phone_number)
    if User.valid_password?(user, password), do: user
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
end
