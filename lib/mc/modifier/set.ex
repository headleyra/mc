defmodule Mc.Modifier.Set do
  use Agent
  use Mc.Railway, [:modify]

  def start_link(kv_client: kv_client) do
    Agent.start_link(fn -> kv_client end, name: __MODULE__)
  end

  def kv_client do
    Agent.get(__MODULE__, & &1)
  end

  def modify(buffer, args) do
    apply(kv_client(), :set, [args, buffer])
  end
end
