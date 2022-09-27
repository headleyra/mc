defmodule Mc.Modifier.Get do
  use Agent
  use Mc.Railway, [:modify]

  def start_link(kv_client: kv_client) do
    Agent.start_link(fn -> kv_client end, name: __MODULE__)
  end

  def kv_client do
    Agent.get(__MODULE__, & &1)
  end

  def modify(_buffer, args) do
    apply(kv_client(), :get, [args])
  end
end
