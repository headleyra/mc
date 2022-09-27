defmodule Mc.Modifier.Map do
  use Mc.Railway, [:modify] 

  def modify(buffer, args) do
    Mc.Modifier.Mapc.modify(buffer, "1 #{args}")
  end
end
