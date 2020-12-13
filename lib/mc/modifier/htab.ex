defmodule Mc.Modifier.Htab do
  use Mc.Railway, [:modify]
  @argspec "<uri encoded css row selector> <uri encoded css column selector>"

  def modify("", _args), do: {:ok, ""}

  def modify(buffer, args) do
    case String.split(args) do
      [row, col] ->
        row_css = Mc.Util.InlineString.uri_decode(row)
        col_css = Mc.Util.InlineString.uri_decode(col)
        {:ok, html} = Floki.parse_fragment(buffer)

        ok_row_col =
          [row_css, col_css]
          |> Enum.all?(fn e -> match?({:ok, _}, e) end)

        if ok_row_col do
          {:ok, ok_row_css} = row_css
          {:ok, ok_col_css} = col_css

          result =
            Floki.find(html, ok_row_css)
            |> Enum.map(fn row_tags -> Floki.find(row_tags, ok_col_css) end)
            |> Enum.map(fn col_tags -> Enum.map(col_tags, fn tag -> Floki.text(tag) end) end)
            |> Enum.map(fn list -> Enum.map(list, fn e -> String.trim(e) end) end)
            |> Enum.map(fn content -> Enum.join(content, "\t") end)
            |> Enum.reject(&(&1 == ""))
            |> Enum.join("\n")
            |> Kernel.<>("\n")

          {:ok, result}
        else
          usage(:modify, @argspec)
        end

      _bad_args ->
        usage(:modify, @argspec)
    end
  end
end
