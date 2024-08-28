defmodule BaselinePhoenix.UserManagerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BaselinePhoenix.UserManager` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{})
      |> BaselinePhoenix.UserManager.create_user()

    user
  end
end
