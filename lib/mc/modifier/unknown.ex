defmodule Mc.Modifier.Unknown do
  use Mc.Modifier

  def m(_buffer, args, _mappings) do
    oops(:modifier_unknown, args)
  end
end
