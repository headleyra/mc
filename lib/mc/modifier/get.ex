defmodule Mc.Modifier.Get do
  use Mc.Railway, [:modify]

  def modify(_buffer, args) do
    kv_adapter().get(args)
  end

  defp kv_adapter do
    Application.get_env(:mc, :kv_adapter)
  end
end
