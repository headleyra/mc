defmodule Mc.Modifier.Range do
  use Mc.Railway, [:modify]

  def modify(_buffer, args) do
    case String.split(args) |> Enum.map(&Mc.String.str2int/1) do
      [{:ok, start}, {:ok, finish}] ->
        {:ok, rangeize(start, finish)}

      [{:ok, finish}] ->
        {:ok, rangeize(1, finish)}

      _bad_args ->
        oops(:modify, "bad range")
    end
  end

  defp rangeize(start, finish) do
    start..finish
    |> Enum.to_list()
    |> Enum.join("\n")
  end
end
