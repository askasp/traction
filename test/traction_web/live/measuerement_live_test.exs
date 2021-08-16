defmodule TractionWeb.MeasuerementLiveTest do
  use TractionWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Traction.Discord

  @create_attrs %{online: 42, total: 42}
  @update_attrs %{online: 43, total: 43}
  @invalid_attrs %{online: nil, total: nil}

  defp fixture(:measuerement) do
    {:ok, measuerement} = Discord.create_measuerement(@create_attrs)
    measuerement
  end

  defp create_measuerement(_) do
    measuerement = fixture(:measuerement)
    %{measuerement: measuerement}
  end

  describe "Index" do
    setup [:create_measuerement]

    test "lists all measurements", %{conn: conn, measuerement: measuerement} do
      {:ok, _index_live, html} = live(conn, Routes.measuerement_index_path(conn, :index))

      assert html =~ "Listing Measurements"
    end

    test "saves new measuerement", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.measuerement_index_path(conn, :index))

      assert index_live |> element("a", "New Measuerement") |> render_click() =~
               "New Measuerement"

      assert_patch(index_live, Routes.measuerement_index_path(conn, :new))

      assert index_live
             |> form("#measuerement-form", measuerement: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#measuerement-form", measuerement: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.measuerement_index_path(conn, :index))

      assert html =~ "Measuerement created successfully"
    end

    test "updates measuerement in listing", %{conn: conn, measuerement: measuerement} do
      {:ok, index_live, _html} = live(conn, Routes.measuerement_index_path(conn, :index))

      assert index_live |> element("#measuerement-#{measuerement.id} a", "Edit") |> render_click() =~
               "Edit Measuerement"

      assert_patch(index_live, Routes.measuerement_index_path(conn, :edit, measuerement))

      assert index_live
             |> form("#measuerement-form", measuerement: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#measuerement-form", measuerement: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.measuerement_index_path(conn, :index))

      assert html =~ "Measuerement updated successfully"
    end

    test "deletes measuerement in listing", %{conn: conn, measuerement: measuerement} do
      {:ok, index_live, _html} = live(conn, Routes.measuerement_index_path(conn, :index))

      assert index_live |> element("#measuerement-#{measuerement.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#measuerement-#{measuerement.id}")
    end
  end

  describe "Show" do
    setup [:create_measuerement]

    test "displays measuerement", %{conn: conn, measuerement: measuerement} do
      {:ok, _show_live, html} = live(conn, Routes.measuerement_show_path(conn, :show, measuerement))

      assert html =~ "Show Measuerement"
    end

    test "updates measuerement within modal", %{conn: conn, measuerement: measuerement} do
      {:ok, show_live, _html} = live(conn, Routes.measuerement_show_path(conn, :show, measuerement))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Measuerement"

      assert_patch(show_live, Routes.measuerement_show_path(conn, :edit, measuerement))

      assert show_live
             |> form("#measuerement-form", measuerement: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#measuerement-form", measuerement: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.measuerement_show_path(conn, :show, measuerement))

      assert html =~ "Measuerement updated successfully"
    end
  end
end
