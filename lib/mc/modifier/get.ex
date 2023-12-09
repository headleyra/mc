defmodule Mc.Modifier.Get do
  use Mc.Railway, [:modify]

  def modify(_buffer, args, _mappings) do
    adapter().get(args)
  end

  defp adapter do
    Application.get_env(:mc, :kv_adapter)
  end
end
