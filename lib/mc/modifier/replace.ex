defmodule Mc.Modifier.Replace do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    case parse(args) do
      {:ok, search_regex, uri_decoded_replace} ->
        result = String.replace(buffer, search_regex, uri_decoded_replace)
        {:ok, result}

      :error ->
        oops("bad search/replace or search regex")
    end
  end

  defp parse(args) do
    with \
      [search, replace] <- String.split(args, ~r/\s+/, parts: 2),
      {:ok, search_regex} <- Regex.compile(search, "sm")
    do
      uri_decoded_replace = URI.decode(replace)
      {:ok, search_regex, uri_decoded_replace}
    else
      _parse_error ->
        :error
    end
  end
end
