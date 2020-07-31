defmodule Mc.Modifier.Zip do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case String.split(args) do
      [separator, key] ->
        try do
          {:ok, zipee} = Mc.modify("", "get #{key}")
          buffer_list = String.split(buffer, "\n")
          zipee_list = String.split(zipee, "\n")
          decoded_separator = URI.decode(separator)

          result =
            Enum.zip(buffer_list, zipee_list)
            |> Enum.map(fn {b, z} -> "#{b}#{decoded_separator}#{z}" end)
            |> Enum.join("\n")

          {:ok, result}
        rescue ArgumentError ->
          {:error, "Zip: bad URI"}
        end

      _bad_args ->
        {:error, "Zip: separator and key required"}
    end
  end
end
