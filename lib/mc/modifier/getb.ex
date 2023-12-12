defmodule Mc.Modifier.Getb do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    {:ok, buffer}
  end
end
