defmodule Go.Modifier.Buffer do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    result =
      args
      |> Mc.String.Inline.decode()
      |> Mcex.Tokenizer.parse()
      |> untokenize(buffer, mappings)

    case result do
      [{:error, reason}] ->
        {:error, reason}

      chardata ->
        {:ok, IO.chardata_to_string(chardata)}
    end
  end

  defp untokenize(tokenized_list, buffer, mappings) do
    tokenized_list
    |> Enum.map(fn char_or_token -> expand(char_or_token, buffer, mappings) end)
    |> Enum.reduce_while([], fn char_or_result, acc -> wrap_result(char_or_result, acc) end)
    |> Enum.reverse()
  end

  defp expand({:ok, chars}, buffer, mappings) do
    script = IO.chardata_to_string(chars)
    Mc.modify(buffer, script, mappings)
  end

  defp expand(char, _buffer, _mappings), do: char

  defp wrap_result({:ok, result}, acc), do: {:cont, [result | acc]}
  defp wrap_result({:error, reason}, _acc), do: {:halt, [{:error, reason}]}
  defp wrap_result(char, acc), do: {:cont, [char | acc]}
end
