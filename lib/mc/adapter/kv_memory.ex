defmodule Mc.Adapter.KvMemory do
  use Agent
  @behaviour Mc.Behaviour.KvAdapter

  def start_link(map: map) do
    Agent.start_link(fn -> map end, name: __MODULE__)
  end

  @impl true
  def set(key, value) do
    Agent.update(__MODULE__, &Map.put(&1, key, value))
    {:ok, value}
  end

  @impl true
  def get(key) do
    value = Agent.get(__MODULE__, &Map.get(&1, key, :not_found))
    if value == :not_found, do: {:error, "not found"}, else: {:ok, value}
  end

  @impl true
  def findk(regex_str) do
    Agent.get(__MODULE__, &finder(&1, regex_str, :key))
  end

  @impl true
  def findv(regex_str) do
    Agent.get(__MODULE__, &finder(&1, regex_str, :value))
  end

  defp finder(map, regx_str, by) do
    case Regex.compile(regx_str) do
      {:ok, regex} ->
        filter(map, regex, by)

      {:error, _} ->
        {:error, "bad regex"}
    end
  end

  defp filter(map, regex, :value), do: filter(map, fn {_key, value} -> Regex.match?(regex, value) end)
  defp filter(map, regex, :key), do: filter(map, fn {key, _value} -> Regex.match?(regex, key) end)
  defp filter(map, func) do
    {:ok,
      map
      |> Enum.to_list()
      |> Enum.filter(func)
      |> Enum.map(fn {key, _value} -> key end)
      |> Enum.join("\n")
    }
  end
end
