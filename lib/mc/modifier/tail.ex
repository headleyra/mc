defmodule Mc.Modifier.Tail do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    case Mc.String.to_int(args) do
      {:ok, count} when count >= 0 ->
        last(buffer, count)

      _bad_args ->
        oops("negative or non-integer line count")
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
