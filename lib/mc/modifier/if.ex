defmodule Mc.Modifier.If do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case String.split(args) do
      [value, true_value, false_value] ->
        compare({:ok, buffer} == Mc.Uri.decode(value), true_value, false_value)

      [true_value, false_value] ->
        compare(buffer == "", true_value, false_value)

      _parse_error ->
        oops(:modify, "parse error")
    end
  end

  defp compare(compare_result, true_value, false_value) do
    if compare_result, do: Mc.Uri.decode(true_value), else: Mc.Uri.decode(false_value)
  end
end
