defmodule Mc.Modifier.Json do
  use Mc.Modifier

  def m(buffer, args, _mappings) do
    json(buffer, args)
  end

  defp json(json, accessor) do
    case Jason.decode(json) do
      {:ok, nil} ->
        {:ok, ""}

      {:ok, map_or_list} ->
        get(map_or_list, accessor)

      {:error, _reason} ->
        oops(:bad_json, json)
    end
  end

  defp get(map, keys) when is_map(map) do
    {:ok,
      String.split(keys)
      |> Enum.reduce([], fn key, acc -> [Map.get(map, key) | acc] end)
      |> Enum.reverse()
      |> Jason.encode!()
    }
  end

  defp get(list, index) when is_list(list) do
    case Ut.String.to_int(index) do
      {:ok, i} when i >= 0 ->
        {:ok,
          Enum.at(list, i)
          |> Jason.encode!()
        }

      _bad_integer ->
        oops(:bad_index, index)
    end
  end
end
