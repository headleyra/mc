defmodule Mc.Modifier.Sortv do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    Mc.String.sort(buffer, ascending: false)
  end
end
