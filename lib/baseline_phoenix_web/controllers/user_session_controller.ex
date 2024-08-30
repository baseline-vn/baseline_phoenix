defmodule BaselinePhoenixWeb.UserSessionController do
  use BaselinePhoenixWeb, :controller

  alias BaselinePhoenix.Accounts
  alias BaselinePhoenixWeb.UserAuth

  def new(conn, _params) do
    render(conn, :new, error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"phone_number" => phone_number, "password" => password} = user_params

    if user = Accounts.get_user_by_phone_number_and_password(phone_number, password) do
      conn
      |> put_flash(:info, "Welcome back!")
      |> UserAuth.sign_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the phone_number is registered.
      render(conn, :new, error_message: "Invalid phone_number or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
