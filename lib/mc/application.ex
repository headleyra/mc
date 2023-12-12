defmodule Mc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Mc.Worker.start_link(arg)
      # {Mc.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mc.Supervisor]
    # opts = [strategy: :rest_for_one, name: Mc.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

