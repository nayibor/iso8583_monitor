defmodule Iso8583MonitorWeb.RuleLive.Index do
  use Iso8583MonitorWeb, :live_view

  alias Iso8583Monitor.Transactions
  alias Iso8583Monitor.Transactions.Rule

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :rules, Transactions.list_rules())}
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
    |> assign(:rule, nil)
  end

  @impl true
  def handle_info({Iso8583MonitorWeb.RuleLive.FormComponent, {:saved, rule}}, socket) do
    {:noreply, stream_insert(socket, :rules, rule)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    rule = Transactions.get_rule!(id)
    {:ok, _} = Transactions.delete_rule(rule)

    {:noreply, stream_delete(socket, :rules, rule)}
  end
end
