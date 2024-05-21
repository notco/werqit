defmodule Werqit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WerqitWeb.Telemetry,
      Werqit.Repo,
      {DNSCluster, query: Application.get_env(:werqit, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Werqit.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Werqit.Finch},
      # Start a worker by calling: Werqit.Worker.start_link(arg)
      # {Werqit.Worker, arg},
      # Start to serve requests, typically the last entry
      WerqitWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Werqit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WerqitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
