defmodule Mc.Modifier.Grepv do
  use Mc.Railway, [:modify]

  def modify(buffer, args, _mappings) do
    case Mc.String.grep(buffer, args, match: false) do
      {:error, reason} ->
        oops(:modify, reason)

      result ->
        result
    end
  end
end
