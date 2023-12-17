defmodule Mc.Modifier.GrepV do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    case Mc.String.grep(buffer, args, match: false) do
      {:error, reason} ->
        oops(reason)

      result ->
        result
    end
  end
end
