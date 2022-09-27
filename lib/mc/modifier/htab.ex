defmodule Mc.Modifier.Htab do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case parse_selectors(args) do
      {:ok, row_css, col_css} ->
        {:ok, html} = Floki.parse_fragment(buffer)

        {:ok,
          Floki.find(html, row_css)
          |> Enum.map(fn row_tags -> Floki.find(row_tags, col_css) end)
          |> Enum.map(fn col_tags -> Enum.map(col_tags, fn tag -> Floki.text(tag) end) end)
          |> Enum.map(fn list -> Enum.map(list, fn e -> String.trim(e) end) end)
          |> Enum.map(fn content -> Enum.join(content, "\t") end)
          |> Enum.reject(fn content -> content == "" end)
          |> Enum.join("\n")
        }

      _error ->
        oops(:modify, "CSS selector parse error")
    end
  end

  defp parse_selectors(args) do
    with \
      [row, col] <- String.split(args),
      {:ok, row_css} <- Mc.String.Inline.uri_decode(row),
      {:ok, col_css} <- Mc.String.Inline.uri_decode(col)
    do
      {:ok, row_css, col_css}
    else
      _error ->
        :error
    end
  end
end
