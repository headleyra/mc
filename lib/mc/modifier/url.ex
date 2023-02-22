defmodule Mc.Modifier.Url do
  use Mc.Railway, [:modify]

  def modify(_buffer, args) do
    http_adapter().get(args)
  end

  defp http_adapter do
    Application.get_env(:mc, :http_adapter)
  end
end
