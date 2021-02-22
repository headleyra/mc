defmodule Mc.Modifier.Range do
  use Mc.Railway, [:modify]

  def modify(_buffer, args) do
    case String.split(args) |> Enum.map(&Mc.Util.Math.str2int(&1)) do
      [{:ok, start}, {:ok, finish}] ->
        {:ok, range_for(start, finish)}

      [{:ok, finish}] ->
        {:ok, range_for(1, finish)}

      _bad_args ->
        usage(:modify, "<integer> [<integer>]")
    end
  end

  def range_for(start, finish) do
    start..finish
    |> Enum.to_list()
    |> Enum.join("\n")
  end
end
