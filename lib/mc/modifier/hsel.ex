defmodule Mc.Modifier.Hsel do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    {:ok, html_parsed} = Floki.parse_fragment(buffer)

    {:ok,
      html_parsed
      |> Floki.find(args)
      |> Floki.raw_html(encode: false)
    }
  end
end
