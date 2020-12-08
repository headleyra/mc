defmodule Mc.MappingsTest do
  use ExUnit.Case, async: false

  setup do
    start_supervised({Mc.Modifier.Kv, map: %{}})
    :ok
  end

  describe "%Mc.Mappings{}" do
    test "defines modifiers that exist" do
      %Mc.Mappings{}
      |> Map.keys()
      |> Enum.reject(fn key -> key == :__struct__ end)
      |> Enum.map(fn key -> Map.get(%Mc.Mappings{}, key) end)
      |> Enum.each(fn {mod, func} -> apply(mod, func, ["", ""]) end)
    end
  end
end
