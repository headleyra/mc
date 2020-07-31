defmodule Mc.Modifier.Replace do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case String.split(args, " ", parts: 2) do
      [search, replace] ->
        try do
          case Regex.compile(search, "sm") do
            {:ok, _} ->
              {:ok, search_regex} = Regex.compile(search, "sm")
              uri_decoded_replace = URI.decode(replace)
              result = String.replace(buffer, search_regex, uri_decoded_replace)
              {:ok, result}

            {:error, _} ->
              {:error, "Replace: bad search regex"}
          end
        rescue ArgumentError ->
          {:error, "Replace: bad URI"}
        end

      [_search] ->
        {:error, "Replace: missing replace term"}
    end
  end
end
