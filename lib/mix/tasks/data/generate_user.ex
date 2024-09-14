defmodule Mix.Tasks.Data.FakeUsers do
  use Mix.Task
  alias BaselinePhoenix.Repo
  alias BaselinePhoenix.Accounts.User

  @moduledoc "Generates fake users for testing purposes"

  # mix data.fake_users
  def run(_) do
    Mix.Task.run("app.start")
    Faker.start()
    Faker.locale(:vi)

    Enum.each(1..100, fn _ ->
      user =
        %User{
          full_name: Faker.Person.first_name() <> " " <> Faker.Person.last_name(),
          province: "lam-dong",
          # province: Enum.random(LocationHelper.province_slugs()),
          onboarded: true,
          verified: true,
          date_of_birth: random_date_of_birth(),
          email: Faker.Internet.email(),
          phone_number: Faker.Phone.EnUs.subscriber_number(10),
          gender: Enum.random(["male", "female"]),
          yrs_experience: Enum.random(1..20),
          played_tournaments: Enum.random([true, false]),
          declared_rank: Enum.random(120..160) * 5,
          court_position: Enum.random(["background", "net", "both"]),
          best_hand: Enum.random(["right-handed", "left-handed", "both"]),
          # avatar: avatar_url,
          vtid: to_string(Faker.random_between(10_000_000, 99_999_999)),
          webauthn_id: :crypto.strong_rand_bytes(64) |> Base.encode64()
        }
        |> Repo.insert!()

      # classic_rank = user.declared_rank

      # %RankClassicEntry{
      #   user_id: user.id,
      #   rank: classic_rank,
      #   changed_by: "Baseline Admin",
      #   change_reason: "Entry rank provided by Baseline Team",
      #   change_amount: 0
      # } |> Repo.insert!()

      # modern_rank = calculate_modern_rank(classic_rank)

      # %RankModernEntry{
      #   user_id: user.id,
      #   rank: Float.round(modern_rank, 4),
      #   changed_by: "Baseline Admin",
      #   change_reason: "Calculated from Classic Entry Rank at Linear Conversion",
      #   change_amount: 0
      # } |> Repo.insert!()

      IO.puts("Created user: #{user.full_name} with rank: #{user.declared_rank}")
    end)
  end

  defp random_date_of_birth do
    today = Date.utc_today()
    min_age = 18
    max_age = 65

    min_date = Date.add(today, -max_age * 365)
    max_date = Date.add(today, -min_age * 365)

    Date.range(min_date, max_date)
    |> Enum.random()
  end

  # defp calculate_modern_rank(classic_rank) do
  #   classic_min = 600
  #   classic_max = 1200
  #   modern_min = 6.9999
  #   modern_max = 1.0000

  #   normalized_rank = (classic_rank - classic_min) / (classic_max - classic_min)
  #   modern_min - ((modern_min - modern_max) * normalized_rank)
  # end
end

# mix data.regenerate_names
defmodule Mix.Tasks.Data.RegenerateNames do
  use Mix.Task
  alias BaselinePhoenix.Repo
  alias BaselinePhoenix.Accounts.User

  @moduledoc "Regenerate full names for existing users"

  def run(_) do
    Mix.Task.run("app.start")
    Faker.start()
    Faker.locale(:vi)

    User
    |> Repo.all()
    |> Enum.each(fn user ->
      new_name = Faker.Person.first_name() <> " " <> Faker.Person.last_name()

      User.changeset(user, %{full_name: new_name})
      |> Repo.update!()

      IO.puts("Updated name for User ID: #{user.id} to #{new_name}")
    end)

    IO.puts("All user names are updated!")
  end
end
