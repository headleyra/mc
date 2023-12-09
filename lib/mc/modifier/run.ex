defmodule Mc.Modifier.Run do
  use Mc.Railway, [:modify]

  def modify(buffer, _args, mappings) do
    Mc.modify("", buffer, mappings)
  end
end
