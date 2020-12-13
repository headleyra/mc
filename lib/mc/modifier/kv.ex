defmodule Mc.Modifier.Kv do
  use Agent
  use Mc.Railway, [:set, :get, :appendk, :prependk, :findk, :findv]
  @behaviour Mc.Behaviour.KvServer
  @argspec "<regex>"

  def start_link(map: map) do
    Agent.start_link(fn -> map end, name: __MODULE__)
  end

  def map do
    Agent.get(__MODULE__, & &1)
  end

  @impl true
  def set(buffer, args) do
    setkey(buffer, args)
  end

  @impl true
  def get(_buffer, args) do
    result = Agent.get(__MODULE__, &Map.get(&1, args, ""))
    {:ok, result}
  end

  @impl true
  def appendk(buffer, args) do
    {:ok, data} = get("", args)
    result = buffer <> data
    {:ok, result}
  end

  @impl true
  def prependk(buffer, args) do
    {:ok, data} = get("", args)
    result = data <> buffer
    {:ok, result}
  end

  @impl true
  def findk(_buffer, args) do
    case Regex.compile(args) do
      {:ok, regex} ->
        find(fn {key, _value} -> Regex.match?(regex, key) end)

      {:error, _} ->
        usage(:findk, @argspec)
    end
  end

  @impl true
  def findv(_buffer, args) do
    case Regex.compile(args) do
      {:ok, regex} ->
        find(fn {_key, value} -> Regex.match?(regex, value) end)

      {:error, _} ->
        usage(:findv, @argspec)
    end
  end

  def find(filter_func) do
    result =
      map()
      |> Enum.to_list()
      |> Enum.filter(filter_func)
      |> Enum.map(fn {key, _value} -> key end)
      |> Enum.join("\n")

    {:ok, result}
  end

  defp setkey(buffer, args) do
    Agent.update(__MODULE__, &Map.put(&1, args, buffer))
    {:ok, buffer}
  end
end
