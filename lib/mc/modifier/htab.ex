defmodule Mc.Modifier.Htab do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    case parse_selectors(args) do
      {row_css, col_css} ->
        {:ok, html} = Floki.parse_fragment(buffer)

        {:ok,
          Floki.find(html, row_css)
          |> Enum.map(fn row_tags -> Floki.find(row_tags, col_css) end)
          |> Enum.map(fn col_tags -> textize(col_tags) end)
          |> Enum.map(fn text_list -> trim(text_list) end)
          |> Enum.map(fn trimmed_text_list -> Enum.join(trimmed_text_list, "\t") end)
          |> Enum.reject(&(&1 == ""))
          |> Enum.join("\n")
        }

      :error ->
        oops(:selector_parse_error, args)
    end
  end

  defp parse_selectors(selectors) do
    case String.split(selectors) do
      [row_css, col_css] ->
        {URI.decode(row_css), URI.decode(col_css)}

      _error ->
        :error
    end
  end

  defp textize(tag_list) do
    Enum.map(tag_list, fn tag -> Floki.text(tag) end)
  end

  defp trim(list) do
    Enum.map(list, fn text -> String.trim(text) end)
  end
end
