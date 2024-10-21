defmodule Mix.Tasks.Data.FakeClubs do
  use Mix.Task
  alias BaselinePhoenix.Repo
  alias BaselinePhoenix.Club

  @moduledoc "Generates fake clubs for testing purposes"

  # mix data.fake_clubs
  def run(_) do
    Mix.Task.run("app.start")
    Faker.start()
    Faker.locale(:vi)

    Enum.each(1..50, fn _ ->
      club =
        %Club{
          about: %{en: Faker.Lorem.paragraph(), vi: Faker.Lorem.paragraph()},
          address: Faker.Address.street_address(),
          cover_data: Faker.Internet.url(),
          email: Faker.Internet.email(),
          logo_data: %{en: Faker.Internet.url(), vi: Faker.Internet.url()},
          name: Faker.Company.name(),
          # Use a custom function
          phone_number: generate_random_phone_number(),
          since: Date.utc_today(),
          # Generates a slug from 3 random words
          slug: Faker.Lorem.words(3) |> Enum.join("-"),
          status: Enum.random([:draft, :review, :active, :archived]),
          verified_organizer: Enum.random([true, false]),
          website: Faker.Internet.url()
        }
        |> Repo.insert!()

      IO.puts("Created club: #{club.name}")
    end)
  end

  # Custom function to generate a random phone number
  defp generate_random_phone_number do
    # Example format
    "0" <> Integer.to_string(:rand.uniform(9_999_999_999))
  end
end
