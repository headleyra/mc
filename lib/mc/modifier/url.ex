defmodule Mc.Modifier.Url do
  use Mc.Modifier

  def modify(_buffer, args, _mappings) do
    adapter().get(args)
  end

  defp adapter do
    Application.get_env(:mc, :http_adapter)
  end
end
