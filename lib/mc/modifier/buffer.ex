defmodule Mc.Modifier.Buffer do
  use Mc.Modifier

  def m(buffer, args, mappings) do
    result =
      args
      |> decode()
      |> tokenize()
      |> untokenize(buffer, mappings)

    case result do
      [{:error, reason}] ->
        {:error, reason}

      chardata ->
        {:ok, IO.chardata_to_string(chardata)}
    end
  end

  defp decode(string) do
    String.split(string, "; ")
    |> Enum.join("\n")
  end

  defp tokenize(string) do
    Mc.Tokenizer.parse(string)
  end

  defp untokenize(tokenized_list, buffer, mappings) do
    tokenized_list
    |> Enum.map(fn char_or_token -> expand(char_or_token, buffer, mappings) end)
    |> Enum.reduce_while([], fn char_or_result, acc -> wrap_result(char_or_result, acc) end)
    |> Enum.reverse()
  end

  defp expand({:token, chars}, buffer, mappings) do
    script = IO.chardata_to_string(chars)
    Mc.m(buffer, script, mappings)
  end

  defp expand(char, _buffer, _mappings), do: char

  defp wrap_result({:ok, result}, acc), do: {:cont, [result | acc]}
  defp wrap_result({:error, reason}, _acc), do: {:halt, [{:error, reason}]}
  defp wrap_result(char, acc), do: {:cont, [char | acc]}
end
