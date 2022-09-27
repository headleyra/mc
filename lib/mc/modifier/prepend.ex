defmodule Mc.Modifier.Prepend do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    {:ok, decoded_string} = Mc.String.Inline.decode(args)
    {:ok, decoded_string <> buffer}
  end
end
