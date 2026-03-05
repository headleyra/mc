defmodule Mc.Modifier.SortV do
  use Mc.Modifier

  def m(buffer, _args, _mappings) do
    Mc.String.sort(buffer, ascending: false)
  end
end
