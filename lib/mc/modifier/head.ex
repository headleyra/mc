defmodule Mc.Modifier.Head do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    case Mc.String.to_int(args) do
      {:ok, count} when count >= 0 ->
        first(buffer, count)

      _error ->
        oops("negative or non-integer line count")
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
