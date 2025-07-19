defmodule Iso8583MonitorWeb.InterfaceLive.Index do
  use Iso8583MonitorWeb, :live_view

  alias Iso8583Monitor.Interfaces
  alias Iso8583Monitor.Interfaces.Interface

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :interfaces, Interfaces.list_interfaces())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Interface")
    |> assign(:interface, Interfaces.get_interface!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Interface")
    |> assign(:interface, %Interface{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Interfaces")
    |> assign(:interface, nil)
  end

  @impl true
  def handle_info({Iso8583MonitorWeb.InterfaceLive.FormComponent, {:saved, interface}}, socket) do
    {:noreply, stream_insert(socket, :interfaces, interface)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    interface = Interfaces.get_interface!(id)
    {:ok, _} = Interfaces.delete_interface(interface)

    {:noreply, stream_delete(socket, :interfaces, interface)}
  end
end
