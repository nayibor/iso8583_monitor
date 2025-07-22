defmodule Iso8583MonitorWeb.InterfaceLive.Index do
  use Iso8583MonitorWeb, :live_view

  alias Iso8583Monitor.Interfaces
  alias Iso8583Monitor.Interfaces.Interface
  alias Iso8583Monitor.Utils
  
  @impl true
  def mount(_params, _session, socket) do
    interfaces = Interfaces.list_interfaces()
    {:ok,
     socket
     |> assign(:page_data,Utils.paginate(1,length(interfaces)))
     |> stream(:interfaces,interfaces )}
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
    |> assign(:form, %{})    
    |> assign(:interface, nil)
  end

  @impl true
  def handle_info({Iso8583MonitorWeb.InterfaceLive.FormComponent, {:saved, _interface}}, socket) do
    interfaces = Interfaces.list_interfaces()
    {:noreply,
    socket 
    |> assign(:page_data,Utils.paginate(1,length(interfaces)))
    |> stream(:interfaces,interfaces,reset: true)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    interface = Interfaces.get_interface!(id)
    {:ok, _} = Interfaces.delete_interface(interface)
    interfaces = Interfaces.list_interfaces()
    {:noreply,
    socket
    |> assign(:page_data,Utils.paginate(1,length(interfaces)))
    |> stream(:interfaces,interfaces,reset: true)}
  end

  @impl true
  def handle_event("paginate", %{"page" => page} = _params, socket) do
    offset = Utils.get_offset(page)
    name = if(Map.get(socket.assigns,:name), do: socket.assigns.name, else: "")
    interfaces = Interfaces.list_interfaces(%{offset: offset,limit: Utils.get_page_size(),name: name})
    {:noreply,
     socket
     |> assign(:name,name)
     |> assign(:page_data,Utils.paginate(page,length(interfaces)))     
     |> stream(:interfaces, interfaces,reset: true)}    	
  end

 @impl true 
  ##this is for a search with a real value
  def handle_event("search", %{"name" => name} = _params, socket) do
    offset = Utils.get_offset(1)
    interfaces = Interfaces.list_interfaces(%{offset: offset,limit: Utils.get_page_size(),name: name})
    {:noreply,
     socket
     |> assign(:name,name)
     |> assign(:page_data,Utils.paginate(1,length(interfaces)))     
     |> stream(:interfaces, interfaces,reset: true)}
  end
end
