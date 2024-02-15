defmodule Mc.Modifier.Erase do
  use Mc.Modifier

  def modify(_buffer, args, _mappings) do
    case adapter().delete(args) do
      1 ->
        {:ok, "1"}

      0 ->
        {:ok, "0"}
    end
  end

  defp adapter do
    Application.get_env(:mc, :kv_adapter)
  end
end
