defmodule Mc.Modifier.Iword do
  use Mc.Railway, [:modify]

  def modify(buffer, _args) do
    case String.trim(buffer) |> Mc.String.str2int() do
      {:ok, int} when int < 0 ->
        {:ok, "(minus) #{Mc.NumberToWord.say(abs(int))}"}

      {:ok, int} ->
        {:ok, Mc.NumberToWord.say(int)}

      :error ->
        {:error, "Mc.Modifier.Iword#modify: no integer found"}
    end
  end
end
