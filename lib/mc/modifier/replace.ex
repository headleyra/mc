defmodule Mc.Modifier.Replace do
  use Mc.Railway, [:modify]

  @help """
  modifier <search regex> <URI-encoded replace string>
  modifier -h

  Replaces all occurences of <search regex> with <URI-encoded replace string>.

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {args_pure, []} ->
        replace(buffer, args_pure)

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:help, :boolean, :h}])
  end

  defp parse_replace(args) do
    with \
      [search, replace] <- String.split(args, " ", parts: 2),
      {:ok, search_regex} <- Regex.compile(search, "sm"),
      {:ok, uri_decoded_replace} <- Mc.String.Inline.uri_decode(replace)
    do
      {:ok, search_regex, uri_decoded_replace}
    else
      _error -> :error
    end
  end

  defp replace(buffer, args) do
    case parse_replace(args) do
      {:ok, search_regex, uri_decoded_replace} ->
        result = String.replace(buffer, search_regex, uri_decoded_replace)
        {:ok, result}

      _error ->
        oops(:modify, "bad search/replace or search regex")
    end
  end
end
