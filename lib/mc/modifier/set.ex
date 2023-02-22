defmodule Mc.Modifier.Set do
  use Agent
  use Mc.Railway, [:modify]

  def start_link(kv_pid: kv_pid) do
    Agent.start_link(fn -> kv_pid end, name: __MODULE__)
  end

  def modify(buffer, args) do
    kv_adapter().set(kv_pid(), args, buffer)
  end

  defp kv_adapter do
    Application.get_env(:mc, :kv_adapter)
  end

  defp kv_pid do
    Agent.get(__MODULE__, &(&1))
  end
end
