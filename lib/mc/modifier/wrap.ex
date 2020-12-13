defmodule Mc.Modifier.Wrap do
  use Mc.Railway, [:modify]
  @argspec "<positive integer>"

  def modify(buffer, args) do
    case Mc.Util.Math.str2int(args) do
      {:ok, column} when column >= 0 ->
        result =
          buffer
          |> String.split("\n")
          |> Enum.map(fn line -> wrap(line, column) end)
          |> Enum.join("\n")

        {:ok, result}

      _error ->
        usage(:modify, @argspec)
    end
  end

  def wrap("", _column), do: ""

  def wrap(text, column) do
    case column do
      col when col > 0 ->
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

      _error ->
        :error
    end
  end
end
