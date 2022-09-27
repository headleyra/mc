defmodule Mc.Modifier.Hselc do
  use Mc.Railway, [:modify, :modifyc]

  def modify(buffer, args) do
    {:ok, html_parsed} = Floki.parse_fragment(buffer)

    {:ok,
      html_parsed
      |> Floki.find(args)
      |> Enum.map(fn {_selector, _attributes, content_list} -> Floki.text(content_list, sep: " ") end)
      |> Enum.map(fn text -> String.trim(text) end)
      |> Enum.join("\n")
    }
  end
end
