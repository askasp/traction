defmodule Traction.DiscordTest do
  use Traction.DataCase

  alias Traction.Discord

  describe "guilds" do
    alias Traction.Discord.Guild

    @valid_attrs %{added_by: "some added_by", guild_id: "some guild_id", guild_name: "some guild_name"}
    @update_attrs %{added_by: "some updated added_by", guild_id: "some updated guild_id", guild_name: "some updated guild_name"}
    @invalid_attrs %{added_by: nil, guild_id: nil, guild_name: nil}

    def guild_fixture(attrs \\ %{}) do
      {:ok, guild} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Discord.create_guild()

      guild
    end

    test "list_guilds/0 returns all guilds" do
      guild = guild_fixture()
      assert Discord.list_guilds() == [guild]
    end

    test "get_guild!/1 returns the guild with given id" do
      guild = guild_fixture()
      assert Discord.get_guild!(guild.id) == guild
    end

    test "create_guild/1 with valid data creates a guild" do
      assert {:ok, %Guild{} = guild} = Discord.create_guild(@valid_attrs)
      assert guild.added_by == "some added_by"
      assert guild.guild_id == "some guild_id"
      assert guild.guild_name == "some guild_name"
    end

    test "create_guild/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Discord.create_guild(@invalid_attrs)
    end

    test "update_guild/2 with valid data updates the guild" do
      guild = guild_fixture()
      assert {:ok, %Guild{} = guild} = Discord.update_guild(guild, @update_attrs)
      assert guild.added_by == "some updated added_by"
      assert guild.guild_id == "some updated guild_id"
      assert guild.guild_name == "some updated guild_name"
    end

    test "update_guild/2 with invalid data returns error changeset" do
      guild = guild_fixture()
      assert {:error, %Ecto.Changeset{}} = Discord.update_guild(guild, @invalid_attrs)
      assert guild == Discord.get_guild!(guild.id)
    end

    test "delete_guild/1 deletes the guild" do
      guild = guild_fixture()
      assert {:ok, %Guild{}} = Discord.delete_guild(guild)
      assert_raise Ecto.NoResultsError, fn -> Discord.get_guild!(guild.id) end
    end

    test "change_guild/1 returns a guild changeset" do
      guild = guild_fixture()
      assert %Ecto.Changeset{} = Discord.change_guild(guild)
    end
  end

  describe "measurements" do
    alias Traction.Discord.Measuerement

    @valid_attrs %{online: 42, total: 42}
    @update_attrs %{online: 43, total: 43}
    @invalid_attrs %{online: nil, total: nil}

    def measuerement_fixture(attrs \\ %{}) do
      {:ok, measuerement} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Discord.create_measuerement()

      measuerement
    end

    test "list_measurements/0 returns all measurements" do
      measuerement = measuerement_fixture()
      assert Discord.list_measurements() == [measuerement]
    end

    test "get_measuerement!/1 returns the measuerement with given id" do
      measuerement = measuerement_fixture()
      assert Discord.get_measuerement!(measuerement.id) == measuerement
    end

    test "create_measuerement/1 with valid data creates a measuerement" do
      assert {:ok, %Measuerement{} = measuerement} = Discord.create_measuerement(@valid_attrs)
      assert measuerement.online == 42
      assert measuerement.total == 42
    end

    test "create_measuerement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Discord.create_measuerement(@invalid_attrs)
    end

    test "update_measuerement/2 with valid data updates the measuerement" do
      measuerement = measuerement_fixture()
      assert {:ok, %Measuerement{} = measuerement} = Discord.update_measuerement(measuerement, @update_attrs)
      assert measuerement.online == 43
      assert measuerement.total == 43
    end

    test "update_measuerement/2 with invalid data returns error changeset" do
      measuerement = measuerement_fixture()
      assert {:error, %Ecto.Changeset{}} = Discord.update_measuerement(measuerement, @invalid_attrs)
      assert measuerement == Discord.get_measuerement!(measuerement.id)
    end

    test "delete_measuerement/1 deletes the measuerement" do
      measuerement = measuerement_fixture()
      assert {:ok, %Measuerement{}} = Discord.delete_measuerement(measuerement)
      assert_raise Ecto.NoResultsError, fn -> Discord.get_measuerement!(measuerement.id) end
    end

    test "change_measuerement/1 returns a measuerement changeset" do
      measuerement = measuerement_fixture()
      assert %Ecto.Changeset{} = Discord.change_measuerement(measuerement)
    end
  end
end
