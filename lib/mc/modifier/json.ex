defmodule Mc.Modifier.Json do
  use Mc.Railway, [:modify, :modifya]

  def modify(buffer, args) do
    case Jason.decode(buffer) do
      {:ok, data} when is_map(data) ->
        {:ok, Map.get(data, args) |> Jason.encode!()}

      {:ok, data} when is_list(data) ->
        list2el(data, args)

      {:ok, nil} ->
        {:error, "Json: null JSON"}

      {:error, _reason} ->
        {:error, "Json: bad JSON"}
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
        {:error, "Json: bad JSON"}

      _not_a_json_array ->
        {:error, "Json: expected a JSON array"}
    end
  end

  def list2el(list, index) do
    case Mc.Util.Math.str2int(index) do
      :error ->
        {:error, "Json: non integer JSON array index: #{index}"}

      index_integer ->
        {:ok, Enum.at(list, index_integer) |> Jason.encode!()}
    end
  end
end
