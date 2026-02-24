defmodule Mc.SelectSpec do
  @valid_part_regx ~r/^[1-9]\d*$|^[1-9]\d*-[1-9]\d*$/

  def parse(spec) do
    spec
    |> split_into_parts()
    |> parse_parts()
    |> expand_to_list()
  end

  defp split_into_parts(spec), do: String.split(spec, ",")

  defp parse_parts(parts) do
    Enum.reduce_while(parts, [], fn part, acc -> parse_part(part, acc) end)
  end

  defp expand_to_list(:error), do: :error

  defp expand_to_list(parts) do
    parts
    |> Enum.reverse() 
    |> Enum.map(&unpack(&1)) 
  end

  defp parse_part(part, acc) do
    if valid_part?(part) do
      {:cont, part_list(part, acc)}
    else
      {:halt, :error}
    end
  end

  defp valid_part?(part) do
    String.match?(part, @valid_part_regx)
  end

  defp part_list(part, acc) do
    next = String.split(part, "-") |> Enum.map(&(String.to_integer(&1) - 1))
    [next | acc]
  end

  defp unpack([a]), do: a
  defp unpack([a, b]) when a < b, do: range(a, b, 1)
  defp unpack([a, b]), do: range(a, b, -1)

  defp range(a, b, step) do
    Range.new(a, b, step)
    |> Enum.to_list()
  end
end
