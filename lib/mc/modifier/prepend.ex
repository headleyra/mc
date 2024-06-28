defmodule Mc.Modifier.Prepend do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    {:ok, args <> buffer}
  end
end
