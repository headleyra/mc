defmodule Mc.Modifier.Set do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    adapter().set(args, buffer)
  end

  defp adapter do
    Application.get_env(:mc, :kv_adapter)
  end
end
