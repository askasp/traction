defmodule TractionWeb.GuildLiveTest do
  use TractionWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Traction.Discord

  @create_attrs %{added_by: "some added_by", guild_id: "some guild_id", guild_name: "some guild_name"}
  @update_attrs %{added_by: "some updated added_by", guild_id: "some updated guild_id", guild_name: "some updated guild_name"}
  @invalid_attrs %{added_by: nil, guild_id: nil, guild_name: nil}

  defp fixture(:guild) do
    {:ok, guild} = Discord.create_guild(@create_attrs)
    guild
  end

  defp create_guild(_) do
    guild = fixture(:guild)
    %{guild: guild}
  end

  describe "Index" do
    setup [:create_guild]

    test "lists all guilds", %{conn: conn, guild: guild} do
      {:ok, _index_live, html} = live(conn, Routes.guild_index_path(conn, :index))

      assert html =~ "Listing Guilds"
      assert html =~ guild.added_by
    end

    test "saves new guild", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.guild_index_path(conn, :index))

      assert index_live |> element("a", "New Guild") |> render_click() =~
               "New Guild"

      assert_patch(index_live, Routes.guild_index_path(conn, :new))

      assert index_live
             |> form("#guild-form", guild: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#guild-form", guild: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.guild_index_path(conn, :index))

      assert html =~ "Guild created successfully"
      assert html =~ "some added_by"
    end

    test "updates guild in listing", %{conn: conn, guild: guild} do
      {:ok, index_live, _html} = live(conn, Routes.guild_index_path(conn, :index))

      assert index_live |> element("#guild-#{guild.id} a", "Edit") |> render_click() =~
               "Edit Guild"

      assert_patch(index_live, Routes.guild_index_path(conn, :edit, guild))

      assert index_live
             |> form("#guild-form", guild: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#guild-form", guild: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.guild_index_path(conn, :index))

      assert html =~ "Guild updated successfully"
      assert html =~ "some updated added_by"
    end

    test "deletes guild in listing", %{conn: conn, guild: guild} do
      {:ok, index_live, _html} = live(conn, Routes.guild_index_path(conn, :index))

      assert index_live |> element("#guild-#{guild.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#guild-#{guild.id}")
    end
  end

  describe "Show" do
    setup [:create_guild]

    test "displays guild", %{conn: conn, guild: guild} do
      {:ok, _show_live, html} = live(conn, Routes.guild_show_path(conn, :show, guild))

      assert html =~ "Show Guild"
      assert html =~ guild.added_by
    end

    test "updates guild within modal", %{conn: conn, guild: guild} do
      {:ok, show_live, _html} = live(conn, Routes.guild_show_path(conn, :show, guild))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Guild"

      assert_patch(show_live, Routes.guild_show_path(conn, :edit, guild))

      assert show_live
             |> form("#guild-form", guild: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#guild-form", guild: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.guild_show_path(conn, :show, guild))

      assert html =~ "Guild updated successfully"
      assert html =~ "some updated added_by"
    end
  end
end
