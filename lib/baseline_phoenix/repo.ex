defmodule BaselinePhoenix.Repo do
  use Ecto.Repo,
    otp_app: :baseline_phoenix,
    adapter: Ecto.Adapters.Postgres
end
