defmodule Mc.Modifier.Hsel do
  use Mc.Railway, [:modify]

  def modify("", _args), do: {:ok, ""}
  def modify(buffer, args) do
    {:ok, html} = Floki.parse_fragment(buffer)
    result =
      Floki.find(html, args)
      |> Floki.raw_html(encode: false)

    {:ok, result}
  end
end
