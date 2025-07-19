defmodule Iso8583MonitorWeb.InterfaceLiveTest do
  use Iso8583MonitorWeb.ConnCase

  import Phoenix.LiveViewTest
  import Iso8583Monitor.InterfacesFixtures

  @create_attrs %{name: "some name", port: 42, status: true, address: "some address", description: "some description", pool_name: "some pool_name", pool_type: :client}
  @update_attrs %{name: "some updated name", port: 43, status: false, address: "some updated address", description: "some updated description", pool_name: "some updated pool_name", pool_type: :server}
  @invalid_attrs %{name: nil, port: nil, status: false, address: nil, description: nil, pool_name: nil, pool_type: nil}

  defp create_interface(_) do
    interface = interface_fixture()
    %{interface: interface}
  end

  describe "Index" do
    setup [:create_interface]

    test "lists all interfaces", %{conn: conn, interface: interface} do
      {:ok, _index_live, html} = live(conn, ~p"/interfaces")

      assert html =~ "Listing Interfaces"
      assert html =~ interface.name
    end

    test "saves new interface", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/interfaces")

      assert index_live |> element("a", "New Interface") |> render_click() =~
               "New Interface"

      assert_patch(index_live, ~p"/interfaces/new")

      assert index_live
             |> form("#interface-form", interface: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#interface-form", interface: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/interfaces")

      html = render(index_live)
      assert html =~ "Interface created successfully"
      assert html =~ "some name"
    end

    test "updates interface in listing", %{conn: conn, interface: interface} do
      {:ok, index_live, _html} = live(conn, ~p"/interfaces")

      assert index_live |> element("#interfaces-#{interface.id} a", "Edit") |> render_click() =~
               "Edit Interface"

      assert_patch(index_live, ~p"/interfaces/#{interface}/edit")

      assert index_live
             |> form("#interface-form", interface: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#interface-form", interface: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/interfaces")

      html = render(index_live)
      assert html =~ "Interface updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes interface in listing", %{conn: conn, interface: interface} do
      {:ok, index_live, _html} = live(conn, ~p"/interfaces")

      assert index_live |> element("#interfaces-#{interface.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#interfaces-#{interface.id}")
    end
  end

  describe "Show" do
    setup [:create_interface]

    test "displays interface", %{conn: conn, interface: interface} do
      {:ok, _show_live, html} = live(conn, ~p"/interfaces/#{interface}")

      assert html =~ "Show Interface"
      assert html =~ interface.name
    end

    test "updates interface within modal", %{conn: conn, interface: interface} do
      {:ok, show_live, _html} = live(conn, ~p"/interfaces/#{interface}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Interface"

      assert_patch(show_live, ~p"/interfaces/#{interface}/show/edit")

      assert show_live
             |> form("#interface-form", interface: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#interface-form", interface: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/interfaces/#{interface}")

      html = render(show_live)
      assert html =~ "Interface updated successfully"
      assert html =~ "some updated name"
    end
  end
end
