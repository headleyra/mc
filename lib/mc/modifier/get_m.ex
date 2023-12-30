defmodule Mc.Modifier.GetM do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    Mc.KvMultiple.get(buffer, args, mappings)
  end
end
