defmodule Mc.Modifier.Zip do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case String.split(args) do
      [key, separator] ->
        {:ok, zipee} = Mc.modify("", "get #{key}")
        buffer_list = String.split(buffer, "\n")
        zipee_list = String.split(zipee, "\n")
        {:ok, decoded_separator} = Mc.Uri.decode(separator)

        {:ok,
          Enum.zip(buffer_list, zipee_list)
          |> Enum.map(fn {b, z} -> "#{b}#{decoded_separator}#{z}" end)
          |> Enum.join("\n")
        }

      _bad_args ->
        oops(:modify, "parse error")
    end
  end
end
