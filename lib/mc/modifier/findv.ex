defmodule Mc.Modifier.Findv do
  use Mc.Railway, [:modify]

  def modify(_buffer, args, _mappings) do
    adapter().findv(args)
    |> wrap_errors()
  end

  defp wrap_errors({:error, reason}), do: oops(:modify, reason)
  defp wrap_errors({:ok, result}), do: {:ok, result}

  defp adapter do
    Application.get_env(:mc, :kv_adapter)
  end
end
