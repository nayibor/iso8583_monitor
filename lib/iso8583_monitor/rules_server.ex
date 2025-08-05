defmodule Iso8583Monitor.RulesServer do
  alias Iso8583Monitor.Interfaces
  use GenServer
  
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{},name: __MODULE__)
  end

  def reload_rules() do
    GenServer.call(__MODULE__, :reload_rules)
  end

  def get_rules() do
     :ets.tab2list(:rules)
  end
  
  @impl true
  def init(state) do
    Interfaces.load_rules()
    {:ok, state}
  end

  @impl true
  def handle_call(:reload_rules, _from, state) do
    Interfaces.load_rules()
    {:reply, :ok, state}
  end
  
  def handle_call(_, _from, state) do
    {:noreply, :ok, state}
  end

  @impl true
  def handle_cast(_, state) do
    {:noreply, state}
  end
  
  @impl true
  def handle_info(_, state) do
    {:noreply, state}
  end
  
end
