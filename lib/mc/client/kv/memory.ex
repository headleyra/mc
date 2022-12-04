defmodule Mc.Client.Kv.Memory do
  use GenServer
  @behaviour Mc.Behaviour.KvClient

  def start_link(map: map, name: name) do
    GenServer.start_link(__MODULE__, [map: map], name: name)
  end

  def map(pid) do
    GenServer.call(pid, :map)
  end

  @impl Mc.Behaviour.KvClient
  def set(pid, key, value) do
    GenServer.call(pid, {:set, key, value})
  end

  @impl Mc.Behaviour.KvClient
  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  @impl Mc.Behaviour.KvClient
  def findk(pid, regex_str) do
    GenServer.call(pid, {:findk, regex_str})
  end

  @impl Mc.Behaviour.KvClient
  def findv(pid, regex_str) do
    GenServer.call(pid, {:findv, regex_str})
  end

  @impl GenServer
  def init(map: map) do
    {:ok, map}
  end

  @impl GenServer
  def handle_call({:findv, regex_str}, _from, map) do
    {:reply, finder(map, regex_str, :value), map}
  end

  @impl GenServer
  def handle_call({:findk, regex_str}, _from, map) do
    {:reply, finder(map, regex_str, :key), map}
  end

  @impl GenServer
  def handle_call(:map, _from, map) do
    {:reply, map, map}
  end

  @impl GenServer
  def handle_call({:get, key}, _from, map) do
    {:reply, {:ok, Map.get(map, key, "")}, map}
  end

  @impl GenServer
  def handle_call({:set, key, value}, _from, map) do
    {:reply, {:ok, value}, Map.put(map, key, value)}
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
