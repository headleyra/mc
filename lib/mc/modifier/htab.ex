defmodule Mc.Modifier.Htab do
  use Mc.Railway, [:modify]
  @argspec "<uri encoded css row selector> <uri encoded css column selector>"

  def modify("", _args), do: {:ok, ""}

  def modify(buffer, args) do
    case parse(args) do
      {:ok, row_css, col_css} ->
        {:ok, html} = Floki.parse_fragment(buffer)

        result =
          Floki.find(html, row_css)
          |> Enum.map(fn row_tags -> Floki.find(row_tags, col_css) end)
          |> Enum.map(fn col_tags -> Enum.map(col_tags, fn tag -> Floki.text(tag) end) end)
          |> Enum.map(fn list -> Enum.map(list, fn e -> String.trim(e) end) end)
          |> Enum.map(fn content -> Enum.join(content, "\t") end)
          |> Enum.reject(&(&1 == ""))
          |> Enum.join("\n")
          |> Kernel.<>("\n")

        {:ok, result}

      _error ->
        usage(:modify, @argspec)
    end
  end

  defp parse(args) do
    case String.split(args) do
      [row, col] ->
        row_css = Mc.Util.InlineString.uri_decode(row)
        col_css = Mc.Util.InlineString.uri_decode(col)

        case [row_css, col_css] do
          [{:ok, ok_row_css}, {:ok, ok_col_css}] ->
            {:ok, ok_row_css, ok_col_css}

          _error ->
            :error
        end

      _error ->
        :error
    end
  end
end
