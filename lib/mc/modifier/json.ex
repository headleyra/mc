defmodule Mc.Modifier.Json do
  use Mc.Railway, [:modify]

  @bad_json "bad JSON"

  @help """
  modifier <accessor>
  modifier -a
  modifier -h

  Parses buffer as JSON and uses <accessor> to access JSON sub-objects (returning a JSON array result).

  -a, --array
    Expects buffer to be a JSON array and returns it as a newline-separated list

  -h, --help
    Show help
  """

  def modify(buffer, args) do
    case parse(args) do
      {_, []} ->
        parse_object(buffer, args)

      {_, [array: true]} ->
        parse_list(buffer)

      {_, [help: true]} ->
        help(:modify, @help)

      :error ->
        oops(:modify, "switch parse error")
    end
  end

  defp parse(args) do
    Mc.Switch.parse(args, [{:array, :boolean, :a}, {:help, :boolean, :h}])
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
        oops(:modify, @bad_json)
    end
  end

  defp parse_list(buffer) do
    case Jason.decode(buffer) do
      {:ok, array} when is_list(array) ->
        {:ok,
          array
          |> Enum.map(&Jason.encode!(&1))
          |> Enum.join("\n")
        }

      {:ok, array} when is_map(array) or is_nil(array) ->
        {:ok, ""}

      {:error, _} ->
        oops(:modify, @bad_json)
    end
  end

  defp map2json(map, keys) do
    String.split(keys)
    |> Enum.reduce([], fn key, acc -> [Map.get(map, key) | acc] end)
    |> Enum.reverse()
    |> Jason.encode!()
  end

  defp list2el(list, index) do
    case Mc.Math.str2int(index) do
      {:ok, i} when i >= 0 ->
        {:ok, Enum.at(list, i) |> Jason.encode!()}

      _bad_integer ->
        oops(:modify, "array index should be >= 0")
    end
  end
end
