defmodule Mc.Modifier.Div do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    try do
      divide(buffer)
    rescue
      ArithmeticError ->
        oops("divide-by-zero attempt")
    end
  end

  defp divide(buffer) do
    case Mc.String.numberize(buffer) do
      {:ok, []} ->
        {:ok, ""}

      {:ok, numbers} ->
        {:ok,
          numbers
          |> Enum.reduce(fn number, acc -> acc / number end)
          |> to_string()
        }
    end
  end
end
