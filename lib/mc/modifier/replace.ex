defmodule Mc.Modifier.Replace do
  use Mc.Railway, [:modify]
  @argspec "<search regex> <replace string>"

  def modify(buffer, args) do
    case parse(args) do
      {:ok, search_regex, uri_decoded_replace} ->
        result = String.replace(buffer, search_regex, uri_decoded_replace)
        {:ok, result}

      _error ->
        usage(:modify, @argspec)
    end
  end

  defp parse(args) do
    with [search, replace] <- String.split(args, " ", parts: 2),
         {:ok, search_regex} <- Regex.compile(search, "sm"),
         {:ok, uri_decoded_replace} <- Mc.InlineString.uri_decode(replace)
    do
      {:ok, search_regex, uri_decoded_replace}
    else
      _ -> :error
    end
  end
end
