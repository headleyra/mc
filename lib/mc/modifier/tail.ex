defmodule Mc.Modifier.Tail do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    case Ut.String.to_int(args) do
      {:ok, count} when count >= 0 ->
        last(buffer, count)

      _bad_line_count ->
        oops(:bad_line_count, args)
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
