defmodule Mc.MappingsTest do
  use ExUnit.Case, async: false
  alias Mc.Adapter.KvMemory

  setup do
    start_supervised({KvMemory, map: %{}})
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
