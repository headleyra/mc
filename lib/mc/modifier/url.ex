defmodule Mc.Modifier.Url do
  use Agent
  use Mc.Railway, [:modify]

  def start_link(http_client: http_client) do
    Agent.start_link(fn -> http_client end, name: __MODULE__)
  end

  def http_client do
    Agent.get(__MODULE__, & &1)
  end

  def modify(_buffer, args) do
    apply(http_client(), :get, [args])
  end
end
