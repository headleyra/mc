defmodule Mc.Modifier.Json do
  use Mc.Railway, [:modify, :modifya]

  def modify(buffer, args) do
    if String.match?(buffer, ~r/^\s*$/), do: {:ok, ""}, else: modify_(buffer, args)
  end

  def modify_(buffer, args) do
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

  def modifya(buffer, _args) do
    case Jason.decode(buffer) do
      {:ok, array} ->
        if is_list(array) do
          result =
            array
            |> Enum.map(fn x -> Jason.encode!(x) end)
            |> Enum.join("\n")

          {:ok, result}
        else
          {:ok, ""}
        end

      {:error, _} ->
        oops(:modifya, "bad JSON")
    end
  end

  def list2el(list, index) do
    case Mc.Util.Math.str2int(index) do
      {:ok, index_integer} ->
        {:ok, Enum.at(list, index_integer) |> Jason.encode!()}

      _non_integer_index ->
        oops(:modify, "non integer JSON array index")
    end
  end
end
