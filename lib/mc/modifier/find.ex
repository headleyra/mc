defmodule Mc.Modifier.Find do
  use Agent
  use Mc.Railway, [:modify]

  def start_link(kv_client: kv_client) do
    Agent.start_link(fn -> kv_client end, name: __MODULE__)
  end

  def kv_client do
    Agent.get(__MODULE__, & &1)
  end

  def modify(_buffer, args) do
    apply(kv_client(), :findk, [args])
    |> wrap_errors()
  end

  defp wrap_errors({:error, reason}), do: oops(:modify, reason)
  defp wrap_errors({:ok, result}), do: {:ok, result}
end
