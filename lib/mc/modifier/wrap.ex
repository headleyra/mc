defmodule Mc.Modifier.Wrap do
  use Mc.Railway, [:modify]
  @err_msg "Wrap: bad wrap number"

  def modify(buffer, args) do
    case Integer.parse(args) do
      {column, _} when column < 1 ->
        {:error, @err_msg}

      {column, _} ->
        result = buffer
        |> String.split("\n")
        |> Enum.map(fn(line) -> wrap(line, column) end)
        |> Enum.join("\n")
        {:ok, result}

      :error ->
        {:error, @err_msg}
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
        |> Enum.map(fn(wrap_chars_list) -> Enum.join(wrap_chars_list) end)
        |> Enum.map(fn(wrap_string) -> String.trim(wrap_string, " ") end)
        |> Enum.join()
        |> String.graphemes()
        |> Enum.chunk_every(col)
        |> Enum.map(fn(wrap_chars_list) -> Enum.join(wrap_chars_list) end)
        |> Enum.join("\n")
    end
  end
end
