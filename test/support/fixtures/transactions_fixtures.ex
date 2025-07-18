defmodule Iso8583Monitor.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Iso8583Monitor.Transactions` context.
  """

  @doc """
  Generate a rule.
  """
  def rule_fixture(attrs \\ %{}) do
    {:ok, rule} =
      attrs
      |> Enum.into(%{
        description: "some description",
        expression: "some expression",
        name: "some name",
        status: true,
        tag: "some tag"
      })
      |> Iso8583Monitor.Transactions.create_rule()

    rule
  end
end
