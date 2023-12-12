defmodule Mc.Modifier.Replace do
  use Mc.Modifier

  def modify(buffer, args, _mappings) do
    case parse_replace(args) do
      {:ok, search_regex, uri_decoded_replace} ->
        result = String.replace(buffer, search_regex, uri_decoded_replace)
        {:ok, result}

      _error ->
        oops("bad search/replace or search regex")
    end
  end

  defp parse_replace(args) do
    with \
      [search, replace] <- String.split(args, ~r/\s+/, parts: 2),
      {:ok, search_regex} <- Regex.compile(search, "sm"),
      {:ok, uri_decoded_replace} <- Mc.Uri.decode(replace)
    do
      {:ok, search_regex, uri_decoded_replace}
    else
      _error -> :error
    end
  end
end
