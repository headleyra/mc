defmodule Mc.Modifier.Iword do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    buffer
    |> String.split()
    |> Enum.map(fn integer_string -> Mc.Util.Math.str2int(integer_string) end)
    |> Enum.reject(fn integer_tuple -> integer_tuple == :error end)
    |> wordify()
  end

  defp to_word(integer) do
    Mc.Util.NumberToWord.say(integer)
  end

  defp wordify(integer_list) do
    result =
      integer_list
      |> Enum.map(fn {:ok, integer} -> to_word(integer) end)
      |> Enum.join("\n")

    {:ok, result}
  end
end
