defmodule Mc.Modifier.Zip do
  use Mc.Railway, [:modify]

  def modify(buffer, args) do
    case String.split(args) do
      [separator, key] ->
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
        oops(:modify, "args parse error")
    end
  end
end
