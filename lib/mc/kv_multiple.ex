defmodule Mc.KvMultiple do
  @default_separator "\n---\n"

  def get(keys, "", mappings), do: expand(keys, @default_separator, mappings)
  def get(keys, separator, mappings), do: expand(keys, separator, mappings)

  def set(setm, "", mappings), do: update(setm, @default_separator, mappings)
  def set(setm, separator, mappings), do: update(setm, separator, mappings)

  def list(keys, mappings) do
    keys
    |> listize(mappings)
    |> Enum.map(fn kv_tuple -> tupleizek(kv_tuple) end)
  end

  defp expand(keys, separator, mappings) do
    {:ok, decoded_separator} = Mc.Uri.decode(separator)

    {:ok,
      keys
      |> listize(mappings)
      |> Enum.map(fn kv_tuple -> stringize(kv_tuple) end)
      |> Enum.join(decoded_separator)
    }
  end

  defp listize(keys, mappings) do
    keys
    |> String.split()
    |> Enum.map(fn key -> {key, Mc.modify("", "get #{key}", mappings)} end)
  end

  defp stringize({key, {:ok, value}}), do: "#{key}\n#{value}"
  defp stringize({key, {:error, _reason}}), do: "#{key}\n"

  defp update(setm, separator, mappings) do
    {:ok, decoded_separator} = Mc.Uri.decode(separator)

    setm
    |> String.split(decoded_separator)
    |> parse()
    |> validate()
    |> set_multiple(setm, mappings)
  end

  defp parse(kv_string_list) do
    kv_string_list
    |> Enum.map(fn kv_string -> tupleizes(kv_string) end)
  end

  defp tupleizes(kv_string) do
    case String.split(kv_string, "\n", parts: 2) do
      [key, value] ->
        {key, value}

      _missing_value ->
        false
    end
  end

  defp validate(kv_tuple_list) do
    if Enum.all?(kv_tuple_list), do: kv_tuple_list, else: false
  end

  defp set_multiple(kv_tuple_list, setm, mappings) do
    if kv_tuple_list do
      Enum.each(kv_tuple_list, fn {key, value} -> Mc.modify(value, "set #{key}", mappings) end)
      {:ok, setm}
    else
      {:error, "bad format"}
    end
  end

  defp tupleizek({key, {:ok, value}}), do: {key, value}
  defp tupleizek({key, {:error, _reason}}), do: {key, ""}
end
