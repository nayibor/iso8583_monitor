defmodule Iso8583Monitor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias Iso8583Monitor.Interfaces
  
  @impl true
  def start(_type, _args) do
    children = [
      Iso8583MonitorWeb.Telemetry,
      Iso8583Monitor.Repo,
      {DNSCluster, query: Application.get_env(:iso8583_monitor, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Iso8583Monitor.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Iso8583Monitor.Finch},
      # Start a worker by calling: Iso8583Monitor.Worker.start_link(arg)
      # {Iso8583Monitor.Worker, arg},
      # Start to serve requests, typically the last entry
      Iso8583MonitorWeb.Endpoint
    ]
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Iso8583Monitor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true  
  def start_phase(:start_interface_servers,_,_) do
    Interfaces.start_interfaces()
    :ok
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Iso8583MonitorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
