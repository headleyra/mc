defmodule Mc.Modifier.Get do
  use Mc.Modifier

  def modify(_buffer, args, _mappings) do
    case adapter().get(args) do
      {:ok, result} ->
        {:ok, result}

      {:error, :not_found} ->
        oops("not found: #{args}")
    end
  end

  defp adapter do
    Application.get_env(:mc, :kv_adapter)
  end
end
