defmodule Iso8583Monitor.InterfacesTest do
  use Iso8583Monitor.DataCase

  alias Iso8583Monitor.Interfaces

  describe "interfaces" do
    alias Iso8583Monitor.Interfaces.Interface

    import Iso8583Monitor.InterfacesFixtures

    @invalid_attrs %{name: nil, port: nil, status: nil, address: nil, description: nil, pool_name: nil, pool_type: nil}

    test "list_interfaces/0 returns all interfaces" do
      interface = interface_fixture()
      assert Interfaces.list_interfaces() == [interface]
    end

    test "get_interface!/1 returns the interface with given id" do
      interface = interface_fixture()
      assert Interfaces.get_interface!(interface.id) == interface
    end

    test "create_interface/1 with valid data creates a interface" do
      valid_attrs = %{name: "some name", port: 42, status: true, address: "some address", description: "some description", pool_name: "some pool_name", pool_type: :client}

      assert {:ok, %Interface{} = interface} = Interfaces.create_interface(valid_attrs)
      assert interface.name == "some name"
      assert interface.port == 42
      assert interface.status == true
      assert interface.address == "some address"
      assert interface.description == "some description"
      assert interface.pool_name == "some pool_name"
      assert interface.pool_type == :client
    end

    test "create_interface/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Interfaces.create_interface(@invalid_attrs)
    end

    test "update_interface/2 with valid data updates the interface" do
      interface = interface_fixture()
      update_attrs = %{name: "some updated name", port: 43, status: false, address: "some updated address", description: "some updated description", pool_name: "some updated pool_name", pool_type: :server}

      assert {:ok, %Interface{} = interface} = Interfaces.update_interface(interface, update_attrs)
      assert interface.name == "some updated name"
      assert interface.port == 43
      assert interface.status == false
      assert interface.address == "some updated address"
      assert interface.description == "some updated description"
      assert interface.pool_name == "some updated pool_name"
      assert interface.pool_type == :server
    end

    test "update_interface/2 with invalid data returns error changeset" do
      interface = interface_fixture()
      assert {:error, %Ecto.Changeset{}} = Interfaces.update_interface(interface, @invalid_attrs)
      assert interface == Interfaces.get_interface!(interface.id)
    end

    test "delete_interface/1 deletes the interface" do
      interface = interface_fixture()
      assert {:ok, %Interface{}} = Interfaces.delete_interface(interface)
      assert_raise Ecto.NoResultsError, fn -> Interfaces.get_interface!(interface.id) end
    end

    test "change_interface/1 returns a interface changeset" do
      interface = interface_fixture()
      assert %Ecto.Changeset{} = Interfaces.change_interface(interface)
    end
  end
end
