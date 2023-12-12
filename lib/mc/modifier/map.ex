defmodule Mc.Modifier.Map do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    Mc.Modifier.Mapc.modify(buffer, "1 #{args}", mappings)
  end
end
