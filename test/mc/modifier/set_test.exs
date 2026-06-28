defmodule Mc.Modifier.SetTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Set

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{}})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "stores `buffer` under the given key and returns `buffer`", %{mappings: mappings} do
      assert Set.m("random\ndata", "x", %{}) == {:ok, "random\ndata"}
      assert Mc.m("get x", mappings) == {:ok, "random\ndata"}
    end

    test "works with ok-tuples", %{mappings: mappings} do
      assert Set.m({:ok, "big tune"}, "yeah", %{}) == {:ok, "big tune"}
      assert Mc.m("get yeah", mappings) == {:ok, "big tune"}
    end

    test "allows error-tuples to pass through" do
      assert Set.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
