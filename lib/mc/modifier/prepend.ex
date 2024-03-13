defmodule Mc.Modifier.Prepend do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    decoded_string = Mc.String.Inline.decode(args)
    {:ok, decoded_string <> buffer}
  end
end
