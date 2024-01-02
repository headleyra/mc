defmodule Mc.Modifier.FindK do
  use Mc.Modifier

  def modify(_buffer, args, _mappings) do
    case adapter().findk(args) do
      {:ok, result} ->
        {:ok, result}

      {:error, reason} ->
        oops(reason)
    end
  end

  defp adapter do
    Application.get_env(:mc, :kv_adapter)
  end
end
