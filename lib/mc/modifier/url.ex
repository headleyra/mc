defmodule Mc.Modifier.Url do
  use Mc.Railway, [:modify]

  def modify(_buffer, args) do
    adapter().get(args)
  end

  defp adapter do
    Application.get_env(:mc, :http_adapter)
  end
end
