defmodule Mc.MappingsTest do
  use ExUnit.Case, async: false
  alias Mc.Adapter.KvMemory

  setup do
    start_supervised({KvMemory, map: %{}})
    :ok
  end

  describe "%Mc.Mappings{}" do
    test "defines modifiers that exist" do
      %Mc.Mappings{}
      |> Map.from_struct()
      |> Map.values()
      |> Enum.each(fn module -> apply(module, :modify, ["", "", %Mc.Mappings{}]) end)
    end
  end
end
