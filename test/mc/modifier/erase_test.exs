defmodule Mc.Modifier.EraseTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Erase

  setup do
    map = %{
      "delly" => "old data"
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "deletes its key and returns 1", %{mappings: mappings} do
      assert Mc.m("get delly", mappings) == {:ok, "old data"}
      assert Erase.m("", "delly", %{}) == {:ok, "1"}
      assert Mc.m("get delly", mappings) == {:error, Mc.Modifier.Get, :key_not_found, "delly", []}
    end

    test "returns 0 when its key doesn't exist" do
      assert Erase.m("n/a", "key-no-exist", %{}) == {:ok, "0"}
    end

    test "works with ok-tuples", %{mappings: mappings} do
      assert Mc.m("get delly", mappings) == {:ok, "old data"}
      assert Erase.m({:ok, "n/a"}, "delly", %{}) == {:ok, "1"}
      assert Mc.m("get delly", mappings) == {:error, Mc.Modifier.Get, :key_not_found, "delly", []}

      assert Erase.m({:ok, ""}, "nokey", %{}) == {:ok, "0"}
    end

    test "allows error-tuples to pass through" do
      assert Erase.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
