defmodule Mc.Modifier.Map do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    Mc.Modifier.MapC.modify(buffer, "1 #{args}", mappings)
  end
end
