defmodule Mc.Client.Kv do
  use Agent
  @behaviour Mc.Behaviour.KvClient

  def start_link(map: map) do
    Agent.start_link(fn -> map end, name: __MODULE__)
  end

  def map do
    Agent.get(__MODULE__, & &1)
  end

  @impl true
  def set(key, value) do
    Agent.update(__MODULE__, &Map.put(&1, key, value))
    {:ok, value}
  end

  @impl true
  def get(key) do
    result = Agent.get(__MODULE__, &Map.get(&1, key, ""))
    {:ok, result}
  end

  @impl true
  def findk(regex) do
    finder(regex, :key)
  end

  @impl true
  def findv(regex) do
    finder(regex, :value)
  end

  defp finder(regx_str, by) do
    case Regex.compile(regx_str) do
      {:ok, regex} ->
        if by == :value do
          filter(fn {_key, value} -> Regex.match?(regex, value) end)
        else
          filter(fn {key, _value} -> Regex.match?(regex, key) end)
        end

      {:error, _} ->
        {:error, "bad regex"}
    end
  end

  defp filter(func) do
    {:ok,
      map()
      |> Enum.to_list()
      |> Enum.filter(func)
      |> Enum.map(fn {key, _value} -> key end)
      |> Enum.join("\n")
    }
  end
end
