defmodule Mc.Modifier.Findv do
  use Agent
  use Mc.Railway, [:modify]

  def start_link(kv_pid: kv_pid) do
    Agent.start_link(fn -> kv_pid end, name: __MODULE__)
  end

  def modify(_buffer, args) do
    kv_adapter().findv(kv_pid(), args)
    |> wrap_errors()
  end

  defp wrap_errors({:error, reason}), do: oops(:modify, reason)
  defp wrap_errors({:ok, result}), do: {:ok, result}

  defp kv_adapter do
    Application.get_env(:mc, :kv_adapter)
  end

  defp kv_pid do
    Agent.get(__MODULE__, &(&1))
  end
end
