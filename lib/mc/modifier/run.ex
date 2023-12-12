defmodule Mc.Modifier.Run do
  use Mc.Modifier

  def modify(buffer, _args, mappings) do
    Mc.modify("", buffer, mappings)
  end
end
