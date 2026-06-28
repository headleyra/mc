defmodule Mc.Modifier.Buffer do
  use Mc.Modifier

  def m(buffer, args, mappings) do
      args
      |> split()
      |> tokenize()
      |> untokenize(buffer, mappings)
      |> result(args)
  end

  defp split(string) do
    string
    |> String.split("; ")
    |> Enum.join("\n")
  end

  defp tokenize(string) do
    Ut.Tokenizer.parse(string)
  end

  defp untokenize(tokenized_list, buffer, mappings) do
    tokenized_list
    |> Enum.map(fn char_or_token -> expand(char_or_token, buffer, mappings) end)
    |> Enum.reduce_while([], fn char_or_result, acc -> wrap(char_or_result, acc) end)
    |> Enum.reverse()
  end

  defp expand({:token, chars}, buffer, mappings) do
    script = IO.chardata_to_string(chars)
    Mc.m(buffer, script, mappings)
  end

  defp expand(char, _buffer, _mappings), do: char

  defp wrap({:ok, result}, acc) do
    {:cont, [result | acc]}
  end

  defp wrap({:error, mod, type, msg, list}, _acc) do
    {:halt, [{:error, mod, type, msg, list}]}
  end

  defp wrap(char, acc) do
    {:cont, [char | acc]}
  end

  defp result(untokenized_list, args) do
    case untokenized_list do
      [{:error, mod, tpe, msg, lst}] ->
        error = {:error, mod, tpe, msg, lst}
        oops(:script_error, args, error)

      chardata ->
        {:ok, IO.chardata_to_string(chardata)}
    end
  end
end
