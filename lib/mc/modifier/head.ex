defmodule Mc.Modifier.Head do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    case Ut.String.to_int(args) do
      {:ok, count} when count >= 0 ->
        first(buffer, count)

      _error ->
        oops(:bad_line_count, args)
    end
  end

  defp first(buffer, count) do
    {:ok,
      buffer
      |> String.split("\n")
      |> Enum.take(count)
      |> Enum.join("\n")
    }
  end
end
