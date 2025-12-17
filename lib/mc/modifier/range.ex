defmodule Mc.Modifier.Range do
  use Mc.Modifier

  def modify(_buffer, args, _mappings) do
    case range(args) do
      [{:ok, start}, {:ok, finish}] ->
        {:ok, rangeize(start, finish)}

      [{:ok, finish}] ->
        {:ok, rangeize(1, finish)}

      _bad_range ->
        oops("bad range")
    end
  end

  defp range(args) do
    String.split(args)
    |> Enum.map(&Mc.String.to_int/1)
  end

  defp rangeize(start, finish) when finish >= start, do: rangeize(start, finish, 1)
  defp rangeize(start, finish), do: rangeize(start, finish, -1)

  defp rangeize(start, finish, step) do
    Range.new(start, finish, step)
    |> Enum.join("\n")
  end
end
