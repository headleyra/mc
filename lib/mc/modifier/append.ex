defmodule Mc.Modifier.Append do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    {:ok, "#{buffer}#{URI.decode(args)}"}
  end
end
