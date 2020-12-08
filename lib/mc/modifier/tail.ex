defmodule Mc.Modifier.Tail do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Integer.parse(args) do
      :error ->
        {:error, "Tail: not an integer"}

      {num, _} when num < 0 ->
        {:error, "Tail: negative"}

      {num, _} ->
        result =
          buffer
          |> String.split("\n")
          |> Enum.reverse()
          |> Enum.take(num)
          |> Enum.reverse()
          |> Enum.join("\n")

        {:ok, result}
    end
  end
end
