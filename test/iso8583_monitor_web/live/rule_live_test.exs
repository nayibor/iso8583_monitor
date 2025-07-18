defmodule Iso8583MonitorWeb.RuleLiveTest do
  use Iso8583MonitorWeb.ConnCase

  import Phoenix.LiveViewTest
  import Iso8583Monitor.TransactionsFixtures

  @create_attrs %{name: "some name", status: true, tag: "some tag", description: "some description", expression: "some expression"}
  @update_attrs %{name: "some updated name", status: false, tag: "some updated tag", description: "some updated description", expression: "some updated expression"}
  @invalid_attrs %{name: nil, status: false, tag: nil, description: nil, expression: nil}

  defp create_rule(_) do
    rule = rule_fixture()
    %{rule: rule}
  end

  describe "Index" do
    setup [:create_rule]

    test "lists all rules", %{conn: conn, rule: rule} do
      {:ok, _index_live, html} = live(conn, ~p"/rules")

      assert html =~ "Listing Rules"
      assert html =~ rule.name
    end

    test "saves new rule", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/rules")

      assert index_live |> element("a", "New Rule") |> render_click() =~
               "New Rule"

      assert_patch(index_live, ~p"/rules/new")

      assert index_live
             |> form("#rule-form", rule: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#rule-form", rule: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/rules")

      html = render(index_live)
      assert html =~ "Rule created successfully"
      assert html =~ "some name"
    end

    test "updates rule in listing", %{conn: conn, rule: rule} do
      {:ok, index_live, _html} = live(conn, ~p"/rules")

      assert index_live |> element("#rules-#{rule.id} a", "Edit") |> render_click() =~
               "Edit Rule"

      assert_patch(index_live, ~p"/rules/#{rule}/edit")

      assert index_live
             |> form("#rule-form", rule: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#rule-form", rule: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/rules")

      html = render(index_live)
      assert html =~ "Rule updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes rule in listing", %{conn: conn, rule: rule} do
      {:ok, index_live, _html} = live(conn, ~p"/rules")

      assert index_live |> element("#rules-#{rule.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#rules-#{rule.id}")
    end
  end

  describe "Show" do
    setup [:create_rule]

    test "displays rule", %{conn: conn, rule: rule} do
      {:ok, _show_live, html} = live(conn, ~p"/rules/#{rule}")

      assert html =~ "Show Rule"
      assert html =~ rule.name
    end

    test "updates rule within modal", %{conn: conn, rule: rule} do
      {:ok, show_live, _html} = live(conn, ~p"/rules/#{rule}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Rule"

      assert_patch(show_live, ~p"/rules/#{rule}/show/edit")

      assert show_live
             |> form("#rule-form", rule: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#rule-form", rule: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/rules/#{rule}")

      html = render(show_live)
      assert html =~ "Rule updated successfully"
      assert html =~ "some updated name"
    end
  end
end
