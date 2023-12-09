defmodule Mc.Modifier.Divide do
  use Mc.Railway, [:modify]

  def modify(buffer, _args, _mappings) do
    try do
      divide(buffer)
    rescue
      ArithmeticError ->
        oops(:modify, "divide-by-zero attempt")
    end
  end

  defp divide(buffer) do
    case Mc.String.numberize(buffer) do
      {:ok, []} ->
        oops(:modify, "no numbers found")

      {:ok, numbers} ->
        {:ok,
          numbers
          |> Enum.reduce(fn number, acc -> acc / number end)
          |> to_string()
        }
    end
  end
end
