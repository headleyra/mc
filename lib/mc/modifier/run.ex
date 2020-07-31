defmodule Mc.Modifier.Run do
  use Mc.Railway, [:modify, :modifyk]

  def modify(buffer, _args) do
    Mc.modify("", buffer)
  end

  def modifyk(buffer, args) do
    {:ok, script} = Mc.modify("", "get #{args}")
    Mc.modify(buffer, script)
  end
end
