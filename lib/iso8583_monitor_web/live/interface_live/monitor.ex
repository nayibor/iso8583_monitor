defmodule Iso8583MonitorWeb.InterfaceLive.Monitor do
  use Iso8583MonitorWeb, :live_view
  alias Iso8583Monitor.Utils
  
  @impl true
  def mount(_params, _session, socket) do
    ##IO.inspect(self())
    transactions = []
    {:ok, stream(socket,:transactions,transactions )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  
  defp apply_action(socket, :index, _params) do
    map_transaction = %{:id => Ecto.UUID.generate(),2 => "4545645645645645",3 => "00100", 4 => "50000", 12 => "1020725",39 => "00",43 => "lashibi spintex branch" }
    send(self(),{:interface_transaction,map_transaction})
    socket
  end

  
  defp apply_action(socket, _,_) do
    socket
  end

  
  @impl true
  def handle_info(_message = {:interface_transaction,map_transaction}, socket) do
    ##IO.inspect(message)
    message_updated = Map.put(map_transaction,:id,Ecto.UUID.generate())
    Process.send_after(self(),{:interface_transaction,message_updated},10000)
    {:noreply,stream_insert(socket,:transactions,map_transaction,limit: -1 * Utils.get_page_size())}
  end


  @impl true
  def handle_info(message, socket) do
    IO.inspect(message)
    {:noreply,socket}
  end  
  
end
