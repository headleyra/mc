defmodule Mc.Modifier.Sort do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    Mc.String.sort(buffer, ascending: true)
  end
end
