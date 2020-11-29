defmodule Mc.Modifier.Htab do
  use Mc.Railway, [:modify]

  def modify("", _args), do: {:ok, ""}

  def modify(buffer, args) do
    case String.split(args) do
      [row, col] ->
        try do
          [row_css, col_css] = [URI.decode(row), URI.decode(col)]
          {:ok, html} = Floki.parse_fragment(buffer)
          result =
            Floki.find(html, row_css)
            |> Enum.map(fn row_tags -> Floki.find(row_tags, col_css) end)
            |> Enum.map(fn col_tags -> Enum.map(col_tags, fn tag -> Floki.text(tag) end) end)
            |> Enum.map(fn list -> Enum.map(list, fn e -> String.trim(e) end) end)
            |> Enum.map(fn content -> Enum.join(content, "\t") end)
            |> Enum.reject(& &1 == "")
            |> Enum.join("\n")
            |> Kernel.<>("\n")

          {:ok, result}
        rescue ArgumentError ->
          {:error, "Htab: bad URI"}
        end

      _bad_args ->
        {:error, "Htab: requires exactly 2 selectors"}
    end
  end
end
