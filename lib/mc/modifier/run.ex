defmodule Mc.Modifier.Run do
  use Mc.Modifier

  def m(buffer, _args, mappings) do
    Mc.m("", buffer, mappings)
  end
end
