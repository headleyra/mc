defmodule Mc.Modifier.Json do
  use Mc.Railway, [:modify, :modifya]

  def modify(buffer, args) do
    case Jason.decode(buffer) do
      {:ok, data} when is_map(data) ->
        {:ok, Map.get(data, args) |> Jason.encode!()}

      {:ok, data} when is_list(data) ->
        list2el(data, args)

      {:ok, nil} ->
        oops(:modify, "null JSON")

      {:error, _reason} ->
        oops(:modify, "bad JSON")
    end
  end

  def modifya(buffer, _args) do
    case Jason.decode(buffer) do
      {:ok, data} when is_list(data) ->
        result =
          data
          |> Enum.map(&Kernel.inspect/1)
          |> Enum.join("\n")

        {:ok, result}

      {:error, _data} ->
        oops(:modifya, "bad JSON")

      _not_a_json_array ->
        oops(:modifya, "expected a JSON array")
    end
  end

  def list2el(list, index) do
    case Mc.Util.Math.str2int(index) do
      {:ok, index_integer} ->
        {:ok, Enum.at(list, index_integer) |> Jason.encode!()}

      _non_integer_index ->
        oops(:modify, "non integer JSON array index: #{index}")
    end
  end
end
