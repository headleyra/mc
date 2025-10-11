defmodule Mc.Modifier.Htab do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
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
        oops("CSS selector parse error")
    end
  end

  defp parse_selectors(args) do
    case String.split(args) do
      [row, col] ->
        row_css = URI.decode(row)
        col_css = URI.decode(col)
        {:ok, row_css, col_css}

      _error ->
        :error
    end
  end
end
