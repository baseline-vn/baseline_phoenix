defmodule BaselinePhoenix.Otp do
  alias BaselinePhoenix.Redix

  def set_otp(phone_number, otp) do
    Redix.set_value_with_timeout("otp:#{phone_number}", otp, 300)
  end
end
