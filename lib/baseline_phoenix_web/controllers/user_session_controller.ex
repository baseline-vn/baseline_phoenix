defmodule BaselinePhoenixWeb.UserSessionController do
  use BaselinePhoenixWeb, :controller

  alias BaselinePhoenix.Accounts
  alias BaselinePhoenix.Otp
  alias BaselinePhoenixWeb.UserAuth

  def new(conn, _params) do
    render(conn, :new, error_message: nil)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, gettext("Logged out successfully."))
    |> UserAuth.log_out_user()
  end

  def create(conn, %{"user" => user_params}) do
    if Map.has_key?(user_params, "otp") do
      verify_otp(conn, user_params)
    else
      handle_phone_number_submission(conn, user_params)
    end
  end

  defp verify_otp(conn, %{"phone_number" => phone_number, "otp" => otp} = user_params) do
    case Accounts.get_or_insert_user_by_phone_number(phone_number) do
      {:ok, user} ->
        if Otp.verify_otp(phone_number, otp) do
          conn
          |> put_flash(:info, gettext("Logged in successfully."))
          |> UserAuth.sign_in_user(user, user_params)
          |> redirect(to: "/")
        else
          render_with_error(conn, :otp, "Invalid OTP", user_params)
        end

      {:error, _changeset} ->
        render_with_error(conn, :new, "Invalid phone number", user_params)
    end
  end

  defp handle_phone_number_submission(conn, %{"phone_number" => phone_number} = user_params) do
    case validate_and_process_phone_number(phone_number) do
      :ok ->
        send_otp_and_render_otp_page(conn, phone_number, user_params)

      {:error, message} ->
        render_with_error(conn, :new, message, user_params)
    end
  end

  defp validate_and_process_phone_number(phone_number) do
    with {:ok, parsed_number} <- ExPhoneNumber.parse(phone_number, "VN"),
         true <- ExPhoneNumber.is_valid_number?(parsed_number),
         {:ok, _user} <- Accounts.get_or_insert_user_by_phone_number(phone_number) do
      :ok
    else
      false -> {:error, "Invalid phone number"}
      {:error, :not_found} -> {:error, "User not found"}
      {:error, _reason} -> {:error, "Invalid phone number format"}
    end
  end

  defp send_otp_and_render_otp_page(conn, phone_number, user_params) do
    Otp.generate_otp(phone_number)
    # TODO: Send OTP to user's phone (implement this part separately)
    conn
    |> put_flash(:info, gettext("OTP sent to your phone"))
    |> render(:otp, changeset: user_params)
  end

  defp render_with_error(conn, template, message, params) do
    conn
    |> put_flash(:error, message)
    |> render(template, changeset: params)
  end
end
