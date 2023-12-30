defmodule Mc.KvMultiple do
  @default_separator "\n---\n"

  def get(string, "", mappings), do: expand(string, @default_separator, mappings)
  def get(string, separator, mappings), do: expand(string, separator, mappings)

  def set(string, "", mappings), do: update(string, @default_separator, mappings)
  def set(string, separator, mappings), do: update(string, separator, mappings)

  defp expand(string, separator, mappings) do
    {:ok, decoded_separator} = Mc.Uri.decode(separator)

    {:ok,
      string
      |> String.split()
      |> Enum.map(fn key -> {key, Mc.modify("", "get #{key}", mappings)} end)
      |> Enum.map(&key_valueize/1)
      |> Enum.join(decoded_separator)
    }
  end

  defp key_valueize({key, {:ok, value}}), do: "#{key}\n#{value}"
  defp key_valueize({key, {:error, "not found"}}), do: "#{key}\n"

  defp update(string, separator, mappings) do
    {:ok, decoded_separator} = Mc.Uri.decode(separator)

    String.split(string, decoded_separator)
    |> parse()
    |> validate()
    |> set_multiple(string, mappings)
  end

  defp parse(kv_strings_list) do
    kv_strings_list
    |> Enum.map(fn kv_string -> to_tuple(kv_string) end)
  end

  defp to_tuple(kv_string) do
    case String.split(kv_string, "\n", parts: 2) do
      [key, value] ->
        {key, value}

      _missing_value ->
        nil
    end
  end

  defp validate(kv_tuple_list) do
    if Enum.all?(kv_tuple_list), do: kv_tuple_list, else: false
  end

  defp set_multiple(kv_tuple_list, string, mappings) do
    if kv_tuple_list do
      Enum.each(kv_tuple_list, fn {key, value} -> Mc.modify(value, "set #{key}", mappings) end)
      {:ok, string}
    else
      {:error, "bad format"}
    end
  end

end
