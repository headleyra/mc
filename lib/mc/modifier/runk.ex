defmodule Mc.Modifier.Runk do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    {:ok, script} = Mc.modify("", "get #{args}")
    Mc.modify(buffer, script)
  end
end
