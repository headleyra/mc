defmodule Mc.Modifier.Sort do
  use Mc.Modifier

  def m(buffer, _args, _mappings) do
    Ut.String.sort(buffer, ascending: true)
  end
end
