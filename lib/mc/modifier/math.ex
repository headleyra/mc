defmodule Mc.Modifier.Math do
  use Mc.Railway, [:add, :subtract, :multiply, :divide]

  def add(buffer, _args), do: op(buffer, :+, :add)
  def subtract(buffer, _args), do: op(buffer, :-, :subtract)
  def multiply(buffer, _args), do: op(buffer, :*, :multiply)
  def divide(buffer, _args), do: op(buffer, :/, :divide)

  def applyop(string, operation) do
    string
    |> String.split()
    |> Enum.map(fn num_str -> Mc.Util.Math.str2num(num_str) end)
    |> Enum.reject(fn num_tuple -> num_tuple == :error end)
    |> Enum.map(fn {:ok, num} -> num end)
    |> (fn
          [_, _ | _] = numbers_list ->
            {:ok, numbers_list |> Enum.reduce(get_func(operation)) |> Kernel.to_string()}

          _less_than_2 ->
            :error
        end).()
  end

  defp op(string, operation, from_func) do
    case applyop(string, operation) do
      :error ->
        oops(from_func, "fewer than two numbers found")

      ok_result ->
        ok_result
    end
  end

  defp get_func(operation) do
    %{
      :+ => fn int, acc -> acc + int end,
      :- => fn int, acc -> acc - int end,
      :* => fn int, acc -> acc * int end,
      :/ => fn int, acc -> acc / int end
    }
    |> Map.get(operation)
  end
end
