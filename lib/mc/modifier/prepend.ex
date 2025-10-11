defmodule Mc.Modifier.Prepend do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    {:ok, "#{URI.decode(args)}#{buffer}"}
  end
end
