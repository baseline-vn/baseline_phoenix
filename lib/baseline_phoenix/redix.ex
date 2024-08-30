defmodule BaselinePhoenix.Redix do
  def set_value_with_timeout(key, value, timeout) do
    Redix.command(:redix, ["SET", key, value, "EX", timeout])
  end
end
