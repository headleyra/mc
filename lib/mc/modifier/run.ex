defmodule Mc.Modifier.Run do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    Mc.modify("", buffer)
  end
end
