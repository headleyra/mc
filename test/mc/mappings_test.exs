defmodule Mc.MappingsTest do
  use ExUnit.Case, async: false

  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.Findk
  alias Mc.Modifier.Findv
  alias Mc.Modifier.Get
  alias Mc.Modifier.Set

  setup do
    start_supervised({KvMemory, map: %{}, name: :cache})
    start_supervised({Get, kv_pid: :cache})
    start_supervised({Set, kv_pid: :cache})
    start_supervised({Findk, kv_pid: :cache})
    start_supervised({Findv, kv_pid: :cache})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "%Mc.Mappings{}" do
    test "defines modifiers that exist" do
      %Mc.Mappings{}
      |> Map.from_struct()
      |> Map.keys()
      |> Enum.map(fn key -> Map.get(%Mc.Mappings{}, key) end)
      |> Enum.each(fn {mod, func} -> apply(mod, func, ["", ""]) end)
    end
  end
end
