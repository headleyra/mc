defmodule Mc.Modifier.Iword do
  use Mc.Modifier

  def m(buffer, _args, _mappings) do
    int = get_int(buffer)

    case Ut.NumberToWord.say(int) do
      {:error, :out_of_range} ->
        oops("out of range")

      {:error, :negative_integer} ->
        oops("negative integer")

      {:error, :non_integer} ->
        oops("no integer found")

      word ->
        {:ok, word}
    end
  end

  def get_int(string) do
    int =
      string
      |> String.trim()
      |> Ut.String.to_int()

    case int do
      {:ok, i} -> i
      :error -> nil
    end
  end
end
