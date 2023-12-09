defmodule Mc.Modifier.Grep do
  use Mc.Railway, [:modify]

  def modify(buffer, args, _mappings) do
    case Mc.String.grep(buffer, args, match: true) do
      {:error, reason} ->
        oops(:modify, reason)

      result ->
        result
    end
  end
end
