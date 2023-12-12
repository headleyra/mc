defmodule Mc.Modifier.Multiply do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    case Mc.String.numberize(buffer) do
      {:ok, []} ->
        oops("no numbers found")

      {:ok, numbers} ->
        {:ok,
          numbers
          |> Enum.reduce(fn number, acc -> acc * number end)
          |> to_string()
        }
    end
  end
end
