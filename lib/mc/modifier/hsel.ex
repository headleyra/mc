defmodule Mc.Modifier.Hsel do
  use Mc.Railway, [:modify]

  @help """
  modifier [-c]
  modifier -h

  Treats the buffer as HTML and selects content given a CSS selector.  By default, HTML tags are returned.

  -c, --content
    Returns the *content* of the tags selected

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        with_tags(buffer, args)

      {args_pure, [content: true]} ->
        without_tags(buffer, args_pure)

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:content, :boolean, :c}, {:help, :boolean, :h}])
  end

  defp with_tags(buffer, args) do
    {:ok,
      parse_html(buffer)
      |> Floki.find(args)
      |> Floki.raw_html(encode: false)
    }
  end

  defp without_tags(buffer, args) do
    {:ok,
      parse_html(buffer)
      |> Floki.find(args)
      |> Enum.map(fn {_selector, _attributes, content_list} -> Floki.text(content_list, sep: " ") end)
      |> Enum.map(fn text -> String.trim(text) end)
      |> Enum.join("\n")
    }
  end

  defp parse_html(html) do
    {:ok, html_parsed} = Floki.parse_fragment(html)
    html_parsed
  end
end
