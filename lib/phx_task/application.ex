defmodule PhxTask.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PhxTask.Repo,
      # Start the Telemetry supervisor
      PhxTaskWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PhxTask.PubSub},
      # Start the Endpoint (http/https)
      PhxTaskWeb.Endpoint
      # Start a worker by calling: PhxTask.Worker.start_link(arg)
      # {PhxTask.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhxTask.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PhxTaskWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
