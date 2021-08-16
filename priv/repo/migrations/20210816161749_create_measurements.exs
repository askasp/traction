defmodule Traction.Repo.Migrations.CreateMeasurements do
  use Ecto.Migration

  def change do
    create table(:measurements) do
      add :total, :integer
      add :online, :integer
      add :guild_id, references(:guilds)

      timestamps()
    end

  end
end
