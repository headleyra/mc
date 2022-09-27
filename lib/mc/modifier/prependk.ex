defmodule Mc.Modifier.Prependk do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    {:ok, data} = Mc.modify("", "get #{args}")
    {:ok, data <> buffer}
  end
end
