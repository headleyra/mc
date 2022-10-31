defmodule Mc.Modifier.Ifk do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case String.split(args) do
      [compare_key, true_value, false_value] ->
        {:ok, compare_value} = Mc.modify("", "get #{compare_key}")
        compare(buffer == compare_value, true_value, false_value)

      _parse_error ->
        oops(:modify, "parse error")
    end
  end

  defp compare(compare_result, true_value, false_value) do
    if compare_result, do: Mc.Uri.decode(true_value), else: Mc.Uri.decode(false_value)
  end
end
