defmodule Traction.Discord.Measuerement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "measurements" do
    field :online, :integer
    field :total, :integer
    belongs_to :guild, Traction.Discord.Guild

    timestamps()
  end

  @doc false
  def changeset(measuerement, attrs) do
    measuerement
    |> cast(attrs, [:total, :online])
    |> validate_required([:total, :online])
  end
end
