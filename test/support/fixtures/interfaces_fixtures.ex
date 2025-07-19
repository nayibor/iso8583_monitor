defmodule Iso8583Monitor.InterfacesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Iso8583Monitor.Interfaces` context.
  """

  @doc """
  Generate a unique interface pool_name.
  """
  def unique_interface_pool_name, do: "some pool_name#{System.unique_integer([:positive])}"

  @doc """
  Generate a interface.
  """
  def interface_fixture(attrs \\ %{}) do
    {:ok, interface} =
      attrs
      |> Enum.into(%{
        address: "some address",
        description: "some description",
        name: "some name",
        pool_name: unique_interface_pool_name(),
        pool_type: :client,
        port: 42,
        status: true
      })
      |> Iso8583Monitor.Interfaces.create_interface()

    interface
  end
end
