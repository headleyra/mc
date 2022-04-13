defmodule Mc.Modifier.Zip do
  use Mc.Railway, [:modify]
  @argspec "<uri encoded separator> <key>"

  def modify(buffer, args) do
    case String.split(args) do
      [separator, key] ->
        {:ok, zipee} = Mc.modify("", "get #{key}")
        buffer_list = String.split(buffer, "\n")
        zipee_list = String.split(zipee, "\n")

        case Mc.InlineString.uri_decode(separator) do
          {:ok, decoded_separator} ->
            result =
              Enum.zip(buffer_list, zipee_list)
              |> Enum.map(fn {b, z} -> "#{b}#{decoded_separator}#{z}" end)
              |> Enum.join("\n")

            {:ok, result}

          _error ->
            usage(:modify, @argspec)
        end

      _bad_args ->
        usage(:modify, @argspec)
    end
  end
end
