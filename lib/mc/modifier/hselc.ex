defmodule Mc.Modifier.Hselc do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    {:ok, html} = Floki.parse_fragment(buffer)
    result =
      Floki.find(html, args)
      |> Enum.map(fn {_selector, _attributes, content_list} -> Floki.text(content_list, sep: " ") end)
      |> Enum.map(fn text -> String.trim(text) end)
      |> Enum.join("\n")

    {:ok, result}
  end
end
