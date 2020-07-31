defmodule Mc.X.Mongokv do
  use Agent
  use Mc.Railway, [:set, :set!, :get, :appendk, :prependk, :findk, :findv]

  def start_link(collection_name) do
    Agent.start_link(fn -> collection_name end, name: __MODULE__)
  end

  def collection_name do
    Agent.get(__MODULE__, & &1)
  end

  def set(buffer, args) do
    if Mc.Util.Sys.writeable_key?(args) do
      setkey(buffer, args)
    else
      {:error, "Set: not allowed: #{args}"}
    end
  end

  def set!(buffer, args) do
    setkey(buffer, args)
  end

  defp setkey(buffer, args) do
    Mongo.update_one(:mongo, collection_name(), %{key: args}, %{"$set": %{value: buffer}}, upsert: true)
    {:ok, buffer}
  end

  def get(_buffer, args) do
    case Mongo.find_one(:mongo, collection_name(), %{key: args}) do
      nil ->
        {:ok, ""}

      document_map ->
        value = document_map["value"]
        {:ok, value}
    end
  end

  def appendk(buffer, args) do
    {:ok, data} = get("", args)
    result = buffer <> data
    {:ok, result}
  end

  def prependk(buffer, args) do
    {:ok, data} = get("", args)
    result = data <> buffer
    {:ok, result}
  end

  def findk(_buffer, args) do
    case Regex.compile(args) do
      {:ok, _} ->
        find(%{key: %{"$regex": args}})

      {:error, _} ->
        {:error, "Findk: bad regex"}
    end
  end

  def findv(_buffer, args) do
    case Regex.compile(args) do
      {:ok, _} ->
        find(%{value: %{"$regex": args}})

      {:error, _} ->
        {:error, "Findv: bad regex"}
    end
  end

  def find(query_map) do
    result =
      Mongo.find(:mongo, collection_name(), query_map, projection: [key: 1, _id: 0])
      |> Enum.to_list()
      |> Enum.map(fn e -> Map.get(e, "key") end)
      |> Enum.join("\n")

    {:ok, result}
  end
end
