defmodule BaselinePhoenix.Otp do
  @otp_length 6
  @otp_ttl :timer.minutes(5)

  def generate_otp(phone_number) do
    otp = :rand.uniform(1_000_000) |> Integer.to_string() |> String.pad_leading(@otp_length, "0")
    Cachex.put(:otp_cache, phone_number, otp, ttl: @otp_ttl)
    otp
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
