defmodule Mc.Modifier.Zip do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    case Mc.Parse.split(args) do
      [script1, script2] ->
        zip(script1, script2, "", buffer, mappings)

      [script1, script2, separator] ->
        zip(script1, script2, URI.decode(separator), buffer, mappings)

      _parse_error ->
        oops("parse error")
    end
  end

  defp zip(script1, script2, separator, buffer, mappings) do
    with \
      {:ok, result1} <- Mc.m(buffer, script1, mappings),
      {:ok, result2} <- Mc.m(buffer, script2, mappings)
    do
      list1 = split(result1)
      list2 = split(result2)

      zipped =
        list1
        |> Enum.zip(list2)
        |> Enum.map_join("\n", fn {a, b} -> "#{a}#{separator}#{b}" end)

      {:ok, zipped}
    else
      {:error, reason} ->
        oops(reason)
    end
  end

  defp split(str) do
    String.split(str, "\n")
  end
end
