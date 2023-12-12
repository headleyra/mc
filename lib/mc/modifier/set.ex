defmodule Mc.Modifier.Set do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    adapter().set(args, buffer)
  end

  defp adapter do
    Application.get_env(:mc, :kv_adapter)
  end
end
