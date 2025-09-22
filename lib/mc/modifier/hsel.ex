defmodule Mc.Modifier.Hsel do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    html_stripped = String.replace(buffer, "\n", "")
    {:ok, html_parsed} = Floki.parse_fragment(html_stripped)

    {:ok,
      html_parsed
      |> Floki.find(args)
      |> Enum.map_join("\n", fn html -> Floki.raw_html(html, encode: false) end)
    }
  end
end
