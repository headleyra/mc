defmodule Mc.Modifier.Json do
  use Mc.Railway, [:modify]

  def modify(buffer, args, _mappings) do
    parse_object(buffer, args)
  end

  defp parse_object(buffer, args) do
    case Jason.decode(buffer) do
      {:ok, data} when is_map(data) ->
        {:ok, map2json(data, args)}

      {:ok, data} when is_list(data) ->
        list2el(data, args)

      {:ok, nil} ->
        {:ok, ""}

      {:error, _reason} ->
        oops(:modify, "bad JSON")
    end
  end

  defp map2json(map, keys) do
    String.split(keys)
    |> Enum.reduce([], fn key, acc -> [Map.get(map, key) | acc] end)
    |> Enum.reverse()
    |> Jason.encode!()
  end

  defp list2el(list, index) do
    case Mc.String.to_int(index) do
      {:ok, i} when i >= 0 ->
        {:ok, Enum.at(list, i) |> Jason.encode!()}

      _bad_integer ->
        oops(:modify, "array index should be >= 0")
    end
  end
end
