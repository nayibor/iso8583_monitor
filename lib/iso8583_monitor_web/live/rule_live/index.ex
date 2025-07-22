defmodule Iso8583MonitorWeb.RuleLive.Index do
  use Iso8583MonitorWeb, :live_view

  alias Iso8583Monitor.Transactions
  alias Iso8583Monitor.Transactions.Rule
  alias Iso8583Monitor.Utils

  @impl true
  def mount(_params, _session, socket) do
    rules = Transactions.list_rules()
    {:ok,
    socket
    |> assign(:page_data,Utils.paginate(1,length(rules)))
    |>  stream(:rules,rules)}
##{:ok, stream(socket, :rules, Transactions.list_rules())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Rule")
    |> assign(:rule, Transactions.get_rule!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Rule")
    |> assign(:rule, %Rule{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Rules")
    |> assign(:form, %{})
    |> assign(:rule, nil)
  end

  @impl true
  def handle_info({Iso8583MonitorWeb.RuleLive.FormComponent, {:saved, _rule}}, socket) do
    rules = Transactions.list_rules()
    {:noreply,
    socket
    |> assign(:page_data,Utils.paginate(1,length(rules)))
    |>  stream(:rules,rules,reset: true)}
    ###{:noreply, stream_insert(socket, :rules, rule)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    rule = Transactions.get_rule!(id)
    {:ok, _} = Transactions.delete_rule(rule)
    rules = Transactions.list_rules()
    {:noreply,
     socket
     |> assign(:page_data,Utils.paginate(1,length(rules)))
     |> stream(:rules,rules,reset: true)}
    ###{:noreply, stream_delete(socket, :rules, rule)}
  end

  ##this is for pagination
  @impl true
  def handle_event("paginate", %{"page" => page} = _params, socket) do
    offset = Utils.get_offset(page)
    name = if(Map.get(socket.assigns,:name), do: socket.assigns.name, else: "")
    rules = Transactions.list_rules(%{offset: offset,limit: Utils.get_page_size(),name: name})
    {:noreply,
     socket
    |> assign(:page_data,Utils.paginate(page,length(rules)))     
    |> stream(:rules,rules,reset: true)}
  end

  @impl true
  ##this is for a search with a real value
  def handle_event("search", %{"name" => name} = _params, socket) do
    offset = Utils.get_offset(1)
    rules = Transactions.list_rules(%{offset: offset,limit: Utils.get_page_size(),name: name})
    {:noreply,
     socket
     |> assign(:name,name)
     |> assign(:page_data,Utils.paginate(1,length(rules)))     
     |> stream(:rules, rules,reset: true)}
  end
  
  
end
