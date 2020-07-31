defmodule Mc.Modifier.Kv do
  use Agent
  use Mc.Railway, [:set, :set!, :get, :appendk, :prependk, :findk, :findv]

  def start_link(state) do
    Agent.start_link(fn -> state end, name: __MODULE__)
  end

  def state do
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
    Agent.update(__MODULE__, & Map.put(&1, args, buffer))
    {:ok, buffer}
  end

  def get(_buffer, args) do
    result = Agent.get(__MODULE__, & Map.get(&1, args, ""))
    {:ok, result}
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
      {:ok, regex} ->
        find(fn {key, _value} -> Regex.match?(regex, key) end)

      {:error, _} ->
        {:error, "Findk: bad regex"}
    end
  end

  def findv(_buffer, args) do
    case Regex.compile(args) do
      {:ok, regex} ->
        find(fn {_key, value} -> Regex.match?(regex, value) end)

      {:error, _} ->
        {:error, "Findv: bad regex"}
    end
  end

  def find(filter_func) do
    result = state()
    |> Enum.to_list()
    |> Enum.filter(filter_func)
    |> Enum.map(fn {key, _value} -> key end)
    |> Enum.join("\n")

    {:ok, result}
  end
end
