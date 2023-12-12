defmodule Mc.Modifier.App do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    {:ok, script} = Mc.App.script(args, mappings)
    Mc.modify(buffer, script, mappings)
  end
end
