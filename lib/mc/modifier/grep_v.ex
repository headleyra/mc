defmodule Mc.Modifier.GrepV do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    case Ut.String.grep(buffer, args, match: false) do
      {:error, _reason} ->
        oops(:bad_regex, args)

      {:ok, result} ->
        {:ok, result}
    end
  end
end
