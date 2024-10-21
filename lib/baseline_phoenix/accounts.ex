defmodule BaselinePhoenix.Accounts do
  @moduledoc """
  The Accounts context.
  """

  require Logger
  import Ecto.Query, warn: false
  alias BaselinePhoenix.Repo
  alias BaselinePhoenix.AvatarUploader
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

  #

  def list_user(params) do
    Flop.validate_and_run(User, params, for: User)
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

  def update_user_avatar(%User{} = user, attrs) do
    result = AvatarUploader.store({attrs["avatar"], user})
    Logger.info("Avatar.store result: #{inspect(result)}")

    case result do
      {:ok, filename} ->
        user
        |> User.avatar_changeset(%{avatar: filename})
        |> Repo.update()
        |> case do
          {:ok, updated_user} ->
            Logger.info("User avatar changeset: #{inspect(updated_user)}")
            Logger.info("User avatar updated successfully. Changeset: #{inspect(updated_user)}")
            {:ok, updated_user}

          {:error, changeset} ->
            Logger.error("Failed to update user avatar: #{inspect(changeset.errors)}")
            {:error, changeset}
        end

      {:error, reason} ->
        Logger.error("Failed to store avatar: #{inspect(reason)}")
        {:error, :avatar_store_failed}
    end
  end

  def change_user_avatar(%User{} = user) do
    User.avatar_changeset(user, %{})
  end
end
