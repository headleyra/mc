defmodule Mc.String do
  def numberize(string) do
    string
    |> String.split()
    |> Enum.map(fn number -> Mc.Math.str2num(number) end)
    |> Enum.reject(fn number_tuple -> number_tuple == :error end)
    |> Enum.map(fn {:ok, number} -> number end)
  end

  def count_char(string, char) do
    String.codepoints(string)
    |> Enum.count(&(&1 == char))
  end
end
