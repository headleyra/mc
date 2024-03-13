defmodule Mc.Modifier.Append do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    decoded_string = Mc.String.Inline.decode(args)
    {:ok, buffer <> decoded_string}
  end
end
