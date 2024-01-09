defmodule Mc.Modifier.AppS do
  use Mc.Modifier

  def modify(_buffer, args, mappings) do
    Mc.App.script(args, mappings)
  end
end
