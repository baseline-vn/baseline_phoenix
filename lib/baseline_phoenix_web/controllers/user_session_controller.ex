defmodule BaselinePhoenixWeb.UserSessionController do
  use BaselinePhoenixWeb, :controller

  alias BaselinePhoenix.Accounts
  alias BaselinePhoenixWeb.UserAuth

  def new(conn, _params) do
    render(conn, :new, error_message: nil)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end

  def create(conn, %{"user" => %{"phone_number" => phone_number} = user_params}) do
    if Map.has_key?(user_params, "otp") do
      verify_otp(conn, user_params)
    else
      handle_user_creation(conn, phone_number, user_params)
    end
  end

  defp verify_otp(conn, %{"phone_number" => phone_number, "otp" => otp} = user_params) do
    case Accounts.get_or_insert_user_by_phone_number(phone_number) do
      {:ok, user} ->
        if otp == "123456" do
          conn
          |> put_flash(:info, "Logged in successfully.")
          |> UserAuth.sign_in_user(user, user_params)
          |> redirect(to: "/")
        else
          conn
          |> put_status(:unprocessable_entity)
          |> render("otp.html", changeset: user_params, error_message: "Invalid OTP")
        end

      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("otp.html", changeset: user_params, error_message: "Error creating account")
    end
  end

  defp handle_user_creation(conn, phone_number, user_params) do
    case Accounts.get_or_insert_user_by_phone_number(phone_number) do
      {:ok, _user} ->
        conn
        |> render(:otp, changeset: user_params)

      _ ->
        # In order to prevent user enumeration attacks, don't disclose whether the phone_number is registered.
        conn
        |> put_status(:unprocessable_entity)
        |> render(:new, error_message: "Error creating account.")
    end
  end
end
