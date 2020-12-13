defmodule Mc.Modifier.Prepend do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Mc.Util.InlineString.decode(args) do
      {:ok, decoded_string} ->
        result = decoded_string <> buffer
        {:ok, result}

      _error ->
        usage(:modify, "<inline string>")
    end
  end
end
