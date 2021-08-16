defmodule Traction.Discord do
  @moduledoc """
  The Discord context.
  """

  import Ecto.Query, warn: false
  alias Traction.Repo

  alias Traction.Discord.Guild

  @doc """
  Returns the list of guilds.

  ## Examples

      iex> list_guilds()
      [%Guild{}, ...]

  """
  def list_guilds do
    Repo.all(Guild)
  end

  @doc """
  Gets a single guild.

  Raises `Ecto.NoResultsError` if the Guild does not exist.

  ## Examples

      iex> get_guild!(123)
      %Guild{}

      iex> get_guild!(456)
      ** (Ecto.NoResultsError)

  """
  def get_guild!(id), do: Repo.get!(Guild, id)

  @doc """
  Creates a guild.

  ## Examples

      iex> create_guild(%{field: value})
      {:ok, %Guild{}}

      iex> create_guild(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_guild(attrs \\ %{}) do
    %Guild{}
    |> Guild.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, x} ->
        :ok = Traction.DiscordPoller.poll_discord()
        {:ok, x}

      y ->
        y
    end
  end

  @doc """
  Updates a guild.

  ## Examples

      iex> update_guild(guild, %{field: new_value})
      {:ok, %Guild{}}

      iex> update_guild(guild, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_guild(%Guild{} = guild, attrs) do
    guild
    |> Guild.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a guild.

  ## Examples

      iex> delete_guild(guild)
      {:ok, %Guild{}}

      iex> delete_guild(guild)
      {:error, %Ecto.Changeset{}}

  """
  def delete_guild(%Guild{} = guild) do
    Repo.delete(guild)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking guild changes.

  ## Examples

      iex> change_guild(guild)
      %Ecto.Changeset{data: %Guild{}}

  """
  def change_guild(%Guild{} = guild, attrs \\ %{}) do
    Guild.changeset(guild, attrs)
  end

  alias Traction.Discord.Measuerement

  @doc """
  Returns the list of measurements.

  ## Examples

      iex> list_measurements()
      [%Measuerement{}, ...]

  """
  def list_measurements do
    Repo.all(Measuerement)
  end

  @doc """
  Gets a single measuerement.

  Raises `Ecto.NoResultsError` if the Measuerement does not exist.

  ## Examples

      iex> get_measuerement!(123)
      %Measuerement{}

      iex> get_measuerement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_measuerement!(id), do: Repo.get!(Measuerement, id)

  @doc """
  Creates a measuerement.

  ## Examples

      iex> create_measuerement(%{field: value})
      {:ok, %Measuerement{}}

      iex> create_measuerement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_measuerement(attrs \\ %{}) do
    %Measuerement{}
    |> Measuerement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a measuerement.

  ## Examples

      iex> update_measuerement(measuerement, %{field: new_value})
      {:ok, %Measuerement{}}

      iex> update_measuerement(measuerement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_measuerement(%Measuerement{} = measuerement, attrs) do
    measuerement
    |> Measuerement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a measuerement.

  ## Examples

      iex> delete_measuerement(measuerement)
      {:ok, %Measuerement{}}

      iex> delete_measuerement(measuerement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_measuerement(%Measuerement{} = measuerement) do
    Repo.delete(measuerement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking measuerement changes.

  ## Examples

      iex> change_measuerement(measuerement)
      %Ecto.Changeset{data: %Measuerement{}}

  """
  def change_measuerement(%Measuerement{} = measuerement, attrs \\ %{}) do
    Measuerement.changeset(measuerement, attrs)
  end
end
