defmodule Mc.Modifier.Findk do
  use Mc.Modifier

  def modify(_buffer, args, _mappings) do
    adapter().findk(args)
    |> wrap_errors()
  end

  defp wrap_errors({:error, reason}), do: oops(reason)
  defp wrap_errors({:ok, result}), do: {:ok, result}

  defp adapter do
    Application.get_env(:mc, :kv_adapter)
  end
end
