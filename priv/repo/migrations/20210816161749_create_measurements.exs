defmodule Traction.Repo.Migrations.CreateMeasurements do
  use Ecto.Migration

  def change do
    create table(:measurements) do
      add :total, :integer, null: false
      add :online, :integer, null: false
      add :guild_id, references(:guilds)

      timestamps()
    end

  end
end
