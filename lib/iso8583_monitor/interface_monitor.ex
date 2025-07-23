defmodule Iso8583Monitor.InterfaceMonitor do
   use GenServer

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  ## Callbacks

  @impl true
  def init(_arg) do   
    {:ok, 0}
  end

  @impl true
  def handle_call(:get, _from, counter) do
    {:reply, counter, counter}
  end

  def handle_call({:bump, value}, _from, counter) do
    {:reply, counter, counter + value}
  end
end
