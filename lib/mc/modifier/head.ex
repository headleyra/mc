defmodule Mc.Modifier.Head do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Integer.parse(args) do
      :error ->
        {:error, "Head: not an integer"}

      {num, _} when num < 0 ->
        {:error, "Head: negative"}

      {num, _} ->
        result =
          buffer
          |> String.split("\n")
          |> Enum.take(num)
          |> Enum.join("\n")

        {:ok, result}
    end
  end
end
