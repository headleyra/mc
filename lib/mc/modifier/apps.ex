defmodule Mc.Modifier.Apps do
  use Mc.Railway, [:modify]

  def modify(_buffer, args, mappings) do
    Mc.App.script(args, mappings)
  end
end
