defmodule Mc.Modifier.Tail do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Mc.Util.Math.str2int(args) do
      {:ok, tail} when tail >= 0 ->
        result =
          buffer
          |> String.split("\n")
          |> Enum.reverse()
          |> Enum.take(tail)
          |> Enum.reverse()
          |> Enum.join("\n")

        {:ok, result}

      _bad_args ->
        usage(:modify, "<positive integer>")
    end
  end
end
