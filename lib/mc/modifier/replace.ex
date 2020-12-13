defmodule Mc.Modifier.Replace do
  use Mc.Railway, [:modify]
  @argspec "<search regex> <replace string>"

  def modify(buffer, args) do
    case String.split(args, " ", parts: 2) do
      [search, replace] ->
        case Regex.compile(search, "sm") do
          {:ok, _} ->
            {:ok, search_regex} = Regex.compile(search, "sm")

            case Mc.Util.InlineString.uri_decode(replace) do
              {:ok, uri_decoded_replace} ->
                result = String.replace(buffer, search_regex, uri_decoded_replace)
                {:ok, result}

              _error ->
                usage(:modify, @argspec)
            end

          _error ->
            usage(:modify, @argspec)
        end

      _error ->
        usage(:modify, @argspec)
    end
  end
end
