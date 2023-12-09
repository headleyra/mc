defmodule Mc.Modifier.App do
  use Mc.Railway, [:modify]

  def modify(buffer, args, mappings) do
    {:ok, script} = Mc.App.script(args, mappings)
    Mc.modify(buffer, script, mappings)
  end
end
