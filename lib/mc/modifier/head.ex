defmodule Mc.Modifier.Head do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Mc.Util.Math.str2int(args) do
      {:ok, num} when num >= 0 ->
        result =
          buffer
          |> String.split("\n")
          |> Enum.take(num)
          |> Enum.join("\n")

        {:ok, result}

      _error ->
        usage(:modify, "<positive integer>")
    end
  end
end
