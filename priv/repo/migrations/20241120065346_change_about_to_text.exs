defmodule BaselinePhoenix.Repo.Migrations.ChangeAboutToText do
  use Ecto.Migration

  def up do
    alter table(:clubs) do
      modify :about, :text
    end
  end

  def down do
    alter table(:clubs) do
      modify :about, :map
    end
  end
end
