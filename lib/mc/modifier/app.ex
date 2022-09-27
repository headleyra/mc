defmodule Mc.Modifier.App do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    {:ok, script} = Mc.App.script(args)
    Mc.modify(buffer, script)
  end
end
