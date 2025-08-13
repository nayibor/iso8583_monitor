defmodule Iso8583MonitorWeb.InterfaceLive.Monitor do
  use Iso8583MonitorWeb, :live_view
  alias Iso8583Monitor.Utils
  
  @impl true
  def mount(_params, _session, socket) do
    :gproc.reg({:p, :l, :liveview_process}, <<"websocket">>)
    {:ok, stream(socket,:transactions,[])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end
  
  defp apply_action(socket, :index, _params) do
    socket
  end
  
  defp apply_action(socket, _,_) do
    socket
  end
  
  @impl true
  def handle_info(_message = {:interface_transaction,map_transaction}, socket) do
    transaction_map_id_added = Map.put(map_transaction,:id,Ecto.UUID.generate())    
    {:noreply,stream_insert(socket,:transactions,transaction_map_id_added,at: 0,limit:  Utils.get_page_size())}
  end

  @impl true
  def handle_info(message, socket) do
    IO.inspect(message)
    {:noreply,socket}
  end  
  
end
