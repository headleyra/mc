defmodule Mc.Modifier.If do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    case String.split(args) do
      [compare_value, true_value, false_value] ->
        compare({:ok, buffer} == Mc.Uri.decode(compare_value), true_value, false_value)

      [true_value, false_value] ->
        compare(String.match?(buffer, ~r/^\s*$/), true_value, false_value)

      _parse_error ->
        oops("parse error")
    end
  end

  defp compare(compare_result, true_value, false_value) do
    if compare_result, do: Mc.Uri.decode(true_value), else: Mc.Uri.decode(false_value)
  end
end
