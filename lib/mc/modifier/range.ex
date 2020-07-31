defmodule Mc.Modifier.Range do
  use Mc.Railway, [:modify]

  def modify(_buffer, args) do
    try do
      case String.split(args) |> Enum.map(& Mc.Util.Math.str2int(&1)) do
        [start, finish] ->
          {:ok, range_for(start, finish)}

        [finish] ->
          {:ok, range_for(1, finish)}

        _bad_args ->
          {:error, "Range: missing limit(s)"}
      end
    rescue ArgumentError ->
      {:error, "Range: limit(s) should be integers"}
    end
  end

  def range_for(start, finish) do
    (start..finish) |> Enum.to_list() |> Enum.join("\n")
  end
end
