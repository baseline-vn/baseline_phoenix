defmodule BaselinePhoenixWeb.UserSessionController do
  use BaselinePhoenixWeb, :controller

  alias BaselinePhoenix.Accounts
  alias BaselinePhoenixWeb.UserAuth

  def new(conn, _params) do
    render(conn, :new, error_message: nil)
  end

  def create(conn, %{"user" => %{"phone_number" => phone_number} = user_params}) do
    case Accounts.get_or_insert_user_by_phone_number(phone_number) do
      {:ok, _user} ->
        conn
        |> render(:otp, changeset: conn.body_params["user"])

      _ ->
        # In order to prevent user enumeration attacks, don't disclose whether the phone_number is registered.
        render(conn, :new, error_message: "Error creating account.")
    end
  end

  def verify_otp(conn, params) do
    user_params = params["user"]
    %{"phone_number" => phone_number, "otp" => otp} = user_params

    case Accounts.get_or_insert_user_by_phone_number(phone_number) do
      {:ok, user} ->
        if otp == "123456" do
          # Logic to log in the user
          conn
          |> put_flash(:info, "Logged in successfully.")
          |> UserAuth.sign_in_user(user, user_params)
          |> redirect(to: ~p"/")
        else
          # Render the form again with an error message
          conn
          |> put_status(:unprocessable_entity)
          |> render(:otp, changeset: conn.body_params["user"])
        end

      _ ->
        # In order to prevent user enumeration attacks, don't disclose whether the phone_number is registered.
        render(conn, :new, error_message: "Error creating account.")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
