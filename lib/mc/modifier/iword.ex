defmodule Mc.Modifier.Iword do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    case String.trim(buffer) |> Mc.String.to_int() do
      {:ok, int} when int < 0 ->
        {:ok, "(minus) #{Mc.NumberToWord.say(abs(int))}"}

      {:ok, int} ->
        {:ok, Mc.NumberToWord.say(int)}

      :error ->
        oops("no integer found")
    end
  end
end
