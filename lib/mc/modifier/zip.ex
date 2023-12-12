defmodule Mc.Modifier.Zip do
  use Mc.Modifier

  def modify(buffer, args, mappings) do
    with \
      [key, separator] <- String.split(args) 
    do
      zip(buffer, key, separator, mappings)
    else
      _bad_args ->
        oops("parse error")
    end
  end

  defp zip(buffer, key, separator, mappings) do
    buffer_list = String.split(buffer, "\n")

    value_list =
      case Mc.modify("", "get #{key}", mappings) do
        {:ok, value} ->
          String.split(value, "\n")

        {:error, "not found"} ->
          [""]
      end

    {:ok, decoded_separator} = Mc.Uri.decode(separator)

    {:ok,
      Enum.zip(buffer_list, value_list)
      |> Enum.map(fn {a, b} -> "#{a}#{decoded_separator}#{b}" end)
      |> Enum.join("\n")
    }
  end
end
