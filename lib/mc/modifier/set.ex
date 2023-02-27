defmodule Mc.Modifier.Set do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    kv_adapter().set(args, buffer)
  end

  defp kv_adapter do
    Application.get_env(:mc, :kv_adapter)
  end
end
