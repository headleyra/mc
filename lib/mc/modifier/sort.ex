defmodule Mc.Modifier.Sort do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    Mc.String.sort(buffer, ascending: true)
  end
end
