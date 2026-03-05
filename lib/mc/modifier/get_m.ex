defmodule Mc.Modifier.GetM do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    Mc.KvMultiple.get(buffer, args, mappings)
  end
end
