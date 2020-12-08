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
    |> Enum.reject(fn num -> num == :error end)
    |> (fn
          [_, _ | _] = numbers_list ->
            {:ok, numbers_list |> Enum.reduce(get_func(operation)) |> Kernel.to_string()}

          _less_than_2 ->
            :error
        end).()
  end

  defp op(string, operation, from_func) do
    case applyop(string, operation) do
      :error -> oops("fewer than two numbers found", from_func)
      ok_result -> ok_result
    end
  end

  defp get_func(operation) do
    %{
      :+ => fn num, acc -> acc + num end,
      :- => fn num, acc -> acc - num end,
      :* => fn num, acc -> acc * num end,
      :/ => fn num, acc -> acc / num end
    }
    |> Map.get(operation)
  end
end
