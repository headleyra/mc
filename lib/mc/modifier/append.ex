defmodule Mc.Modifier.Append do
  use Mc.Railway, [:modify]

  def modify(buffer, args, _mappings) do
    {:ok, decoded_string} = Mc.String.Inline.decode(args)
    {:ok, buffer <> decoded_string}
  end
end
