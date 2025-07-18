defmodule Iso8583Monitor.TransactionsTest do
  use Iso8583Monitor.DataCase

  alias Iso8583Monitor.Transactions

  describe "rules" do
    alias Iso8583Monitor.Transactions.Rule

    import Iso8583Monitor.TransactionsFixtures

    @invalid_attrs %{name: nil, status: nil, tag: nil, description: nil, expression: nil}

    test "list_rules/0 returns all rules" do
      rule = rule_fixture()
      assert Transactions.list_rules() == [rule]
    end

    test "get_rule!/1 returns the rule with given id" do
      rule = rule_fixture()
      assert Transactions.get_rule!(rule.id) == rule
    end

    test "create_rule/1 with valid data creates a rule" do
      valid_attrs = %{name: "some name", status: true, tag: "some tag", description: "some description", expression: "some expression"}

      assert {:ok, %Rule{} = rule} = Transactions.create_rule(valid_attrs)
      assert rule.name == "some name"
      assert rule.status == true
      assert rule.tag == "some tag"
      assert rule.description == "some description"
      assert rule.expression == "some expression"
    end

    test "create_rule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_rule(@invalid_attrs)
    end

    test "update_rule/2 with valid data updates the rule" do
      rule = rule_fixture()
      update_attrs = %{name: "some updated name", status: false, tag: "some updated tag", description: "some updated description", expression: "some updated expression"}

      assert {:ok, %Rule{} = rule} = Transactions.update_rule(rule, update_attrs)
      assert rule.name == "some updated name"
      assert rule.status == false
      assert rule.tag == "some updated tag"
      assert rule.description == "some updated description"
      assert rule.expression == "some updated expression"
    end

    test "update_rule/2 with invalid data returns error changeset" do
      rule = rule_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_rule(rule, @invalid_attrs)
      assert rule == Transactions.get_rule!(rule.id)
    end

    test "delete_rule/1 deletes the rule" do
      rule = rule_fixture()
      assert {:ok, %Rule{}} = Transactions.delete_rule(rule)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_rule!(rule.id) end
    end

    test "change_rule/1 returns a rule changeset" do
      rule = rule_fixture()
      assert %Ecto.Changeset{} = Transactions.change_rule(rule)
    end
  end
end
