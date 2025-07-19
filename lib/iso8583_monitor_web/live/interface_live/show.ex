defmodule Iso8583MonitorWeb.InterfaceLive.Show do
  use Iso8583MonitorWeb, :live_view

  alias Iso8583Monitor.Interfaces

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:interface, Interfaces.get_interface!(id))}
  end

  defp page_title(:show), do: "Show Interface"
  defp page_title(:edit), do: "Edit Interface"
end
