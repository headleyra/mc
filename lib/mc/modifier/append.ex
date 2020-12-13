defmodule Mc.Modifier.Append do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Mc.Util.InlineString.decode(args) do
      {:ok, decoded_string} ->
        result = buffer <> decoded_string
        {:ok, result}

      _error ->
        usage(:modify, "<inline string>")
    end
  end
end
