defmodule Mc.Modifier.Grep do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    case Ut.String.grep(buffer, args, match: true) do
      {:error, _reason} ->
        oops(:bad_regex, args)

      {:ok, result} ->
        {:ok, result}
    end
  end
end
