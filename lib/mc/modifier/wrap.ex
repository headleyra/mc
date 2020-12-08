defmodule Mc.Modifier.Wrap do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case Integer.parse(args) do
      {column, _} when column < 1 ->
        oops("bad column number", :modify)

      {column, _} ->
        result =
          buffer
          |> String.split("\n")
          |> Enum.map(fn line -> wrap(line, column) end)
          |> Enum.join("\n")

        {:ok, result}

      :error ->
        oops("bad column number", :modify)
    end
  end

  def wrap("", _column), do: ""

  def wrap(text, column) do
    case column do
      col when col < 1 ->
        :error

      col ->
        text
        |> String.graphemes()
        |> Enum.chunk_every(col)
        |> Enum.map(fn wrap_chars_list -> Enum.join(wrap_chars_list) end)
        |> Enum.map(fn wrap_string -> String.trim(wrap_string, " ") end)
        |> Enum.join()
        |> String.graphemes()
        |> Enum.chunk_every(col)
        |> Enum.map(fn wrap_chars_list -> Enum.join(wrap_chars_list) end)
        |> Enum.join("\n")
    end
  end
end
