defmodule Mc.Modifier.Apps do
  use Mc.Railway, [:modify]

  def modify(_buffer, args) do
    Mc.App.script(args)
  end
end
