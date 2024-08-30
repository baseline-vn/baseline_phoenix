defmodule BaselinePhoenix.Repo.Migrations.DropUserTokenTable do
  use Ecto.Migration

  def change do
    drop table(:users_tokens)
  end
end
