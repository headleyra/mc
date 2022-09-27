defmodule Mc.Modifier.Appendk do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    {:ok, data} = Mc.modify("", "get #{args}")
    {:ok, buffer <> data}
  end
end
