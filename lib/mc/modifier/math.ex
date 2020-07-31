defmodule Mc.Modifier.Math do
  use Mc.Railway, [:add, :subtract, :multiply, :divide]

  def add(buffer, _args), do: apply_func(buffer, "Add")
  def subtract(buffer, _args), do: apply_func(buffer, "Sub")
  def multiply(buffer, _args), do: apply_func(buffer, "Mul")
  def divide(buffer, _args), do: apply_func(buffer, "Div")

  def apply_func(string, operation) do
    string
    |> String.split()
    |> Enum.map(fn num_str -> Mc.Util.Math.str2num(num_str) end)
    |> Enum.reject(fn num -> num == :error end)
    |> (fn
          [_, _ | _] = numbers_list ->
            {:ok, numbers_list |> Enum.reduce(get_func(operation)) |> Kernel.to_string()}

          _less_than_2 ->
            {:error, "#{operation}: fewer than two numbers found"}
        end).()
  end

  defp get_func(operation) do
    %{
      "Add" => fn num, acc -> acc + num end,
      "Sub" => fn num, acc -> acc - num end,
      "Mul" => fn num, acc -> acc * num end,
      "Div" => fn num, acc -> acc / num end
    }
    |> Map.get(operation)
  end
end
