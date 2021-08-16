defmodule Traction.Repo.Migrations.CreateGuilds do
  use Ecto.Migration

  def change do
    create table(:guilds) do
      add :guild_id, :string
      add :guild_name, :string
      add :added_by, :string
      add :poll_intervall, :integer

      timestamps()
    end

  end
end
