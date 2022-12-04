defmodule Mc.Modifier.Set do
  use Agent
  use Mc.Railway, [:modify]

  def start_link(kv_client: kv_client, kv_pid: kv_pid) do
    Agent.start_link(fn -> {kv_client, kv_pid} end, name: __MODULE__)
  end

  def kv_client do
    Agent.get(__MODULE__, fn {kv_client, _} -> kv_client end)
  end

  def kv_pid do
    Agent.get(__MODULE__, fn {_, kv_pid} -> kv_pid end)
  end

  def modify(buffer, args) do
    apply(kv_client(), :set, [kv_pid(), args, buffer])
  end
end
