defmodule BaselinePhoenix.Otp do
  alias BaselinePhoenix.Telegram

  @otp_length 6
  @otp_ttl :timer.minutes(5)

  def generate_otp(phone_number) do
    try do
      otp =
        :rand.uniform(1_000_000) |> Integer.to_string() |> String.pad_leading(@otp_length, "0")

      Cachex.put(:otp_cache, phone_number, otp, ttl: @otp_ttl)

      case Telegram.send_otp(phone_number, otp) do
        {:ok, _response} ->
          IO.puts("Sending OTP #{otp} to #{phone_number}")
          {:ok, otp}

        {:error, reason} ->
          IO.puts("Failed to send OTP to #{phone_number}: #{inspect(reason)}")
          {:error, reason}
      end
    catch
      error ->
        IO.puts("An error occurred while generating or sending OTP: #{inspect(error)}")
        {:error, :otp_generation_failed}
    end
  end

  def verify_otp(phone_number, otp) do
    case Cachex.get(:otp_cache, phone_number) do
      {:ok, ^otp} ->
        Cachex.del(:otp_cache, phone_number)
        true

      _ ->
        false
    end
  end
end
