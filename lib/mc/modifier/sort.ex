defmodule Mc.Modifier.Sort do
  use Mc.Railway, [:modify]

  def modify(buffer, _args, _mappings) do
    Mc.String.sort(buffer, ascending: true)
  end
end
