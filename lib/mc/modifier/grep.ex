defmodule Mc.Modifier.Grep do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    case Mc.String.grep(buffer, args, match: true) do
      {:error, reason} ->
        oops(reason)

      result ->
        result
    end
  end
end
