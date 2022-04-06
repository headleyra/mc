defmodule Mc.Modifier.Iword do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    case String.trim(buffer) |> Mc.Util.Math.str2int() do
      {:ok, int} when int < 0 ->
        {:ok, "(minus) #{Mc.Util.NumberToWord.say(abs(int))}"}

      {:ok, int} ->
        {:ok, Mc.Util.NumberToWord.say(int)}

      :error ->
        {:error, "Mc.Modifier.Iword#modify: no integer found"}
    end
  end

  # def modify(buffer, _args) do
  #   buffer
  #   |> String.split()
  #   |> Enum.map(fn integer_string -> Mc.Util.Math.str2int(integer_string) end)
  #   |> Enum.reject(fn integer_tuple -> integer_tuple == :error end)
  #   |> wordify()
  # end

  # defp to_word(integer) do
  #   Mc.Util.NumberToWord.say(integer)
  # end

  # defp wordify(integer_list) do
  #   result =
  #     integer_list
  #     |> Enum.map(fn {:ok, integer} -> to_word(integer) end)
  #     |> Enum.join("\n")

  #   {:ok, result}
  # end
end
