defmodule Mc.Modifier.Tail do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Mc.String.str2int(args) do
      {:ok, count} when count >= 0 ->
        last(buffer, count)

      _bad_args ->
        oops(:modify, "negative or non-integer line count")
    end
  end

  defp last(buffer, count) do
    {:ok,
      buffer
      |> String.split("\n")
      |> Enum.reverse()
      |> Enum.take(count)
      |> Enum.reverse()
      |> Enum.join("\n")
    }
  end
end
