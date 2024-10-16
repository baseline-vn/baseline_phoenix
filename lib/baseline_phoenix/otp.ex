defmodule BaselinePhoenix.Otp do
  alias BaselinePhoenix.Telegram
  require Logger

  @otp_length 6
  @otp_ttl :timer.minutes(5)

  def verify_otp(phone_number, otp) do
    case Cachex.get(:otp_cache, phone_number) do
        {:ok, ^otp} ->
        Cachex.del(:otp_cache, phone_number)
        true

      _ ->
        false
    end
  end

  def generate_otp(phone_number) do
    otp = generate_random_otp()

    with {:ok, _response} <- store_otp(phone_number, otp),
         {:ok, _response} <- send_otp_via_telegram(phone_number, otp) do
      {:ok, otp}
    else
      {:error, reason} ->
        Logger.error("Failed to generate or send OTP: #{inspect(reason)}")
        {:error, :otp_generation_failed}
    end
  end

  defp generate_random_otp do
    :rand.uniform(1_000_000) |> Integer.to_string() |> String.pad_leading(@otp_length, "0")
  end

  defp store_otp(phone_number, otp) do
    Cachex.put(:otp_cache, phone_number, otp, ttl: @otp_ttl)
  end

  defp send_otp_via_telegram(phone_number, otp) do
    case Telegram.send_otp(phone_number, otp) do
      {:ok, response} ->
        Logger.info("Sent OTP #{otp} to #{phone_number}")
        {:ok, response}

      {:error, reason} = error ->
        Logger.error("Failed to send OTP to #{phone_number}: #{inspect(reason)}")
        error
    end
  end
end
