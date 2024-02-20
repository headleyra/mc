defmodule Mc.Modifier.Add do
  use Mc.Modifier

  def modify(buffer, _args, _mappings) do
    case Mc.String.numberize(buffer) do
      {:ok, []} ->
        {:ok, ""}

      {:ok, numbers} ->
        {:ok,
          numbers
          |> Enum.reduce(fn number, acc -> acc + number end)
          |> to_string()
        }
    end
  end
end
