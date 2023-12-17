defmodule Mc.Modifier.IfK do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    case String.split(args) do
      [compare_key, true_value, false_value] ->
        {:ok, compare_value} = Mc.modify("", "get #{compare_key}", mappings)
        compare(buffer == compare_value, true_value, false_value)

      _parse_error ->
        oops("parse error")
    end
  end

  defp compare(compare_result, true_value, false_value) do
    if compare_result, do: Mc.Uri.decode(true_value), else: Mc.Uri.decode(false_value)
  end
end
