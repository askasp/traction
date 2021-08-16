defmodule Traction.Discord.Guild do
  use Ecto.Schema
  import Ecto.Changeset

  schema "guilds" do
    field :added_by, :string
    field :guild_id, :string
    field :guild_name, :string
    field :poll_intervall, :integer
    has_many :measurements, Traction.Discord.Measuerement

    timestamps()
  end

  @doc false
  def changeset(guild, attrs) do
    guild
    |> cast(attrs, [:guild_id, :guild_name, :added_by, :poll_intervall])
    |> validate_required([:guild_id, :guild_name, :added_by])
  end
end
