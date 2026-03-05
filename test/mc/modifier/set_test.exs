defmodule Mc.Modifier.SetTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Set

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{}})
    :ok
  end

  describe "m/3" do
    test "stores `buffer` under the given key and returns `buffer`" do
      assert Set.m("random data", "rand", %{}) == {:ok, "random data"}
      assert Set.m("stuff", "_x", %{}) == {:ok, "stuff"}
    end

    test "works with ok tuples" do
      assert Set.m({:ok, "big tune"}, "yeah", %{}) == {:ok, "big tune"}
    end

    test "allows error tuples to pass through" do
      assert Set.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
