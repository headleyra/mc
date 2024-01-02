defmodule Mc.Modifier.SetTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Set

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{}})
    :ok
  end

  describe "modify/3" do
    test "stores `buffer` under the given key and returns `buffer`" do
      assert Set.modify("random data", "rand", %{}) == {:ok, "random data"}
      assert Set.modify("stuff", "_x", %{}) == {:ok, "stuff"}
    end

    test "works with ok tuples" do
      assert Set.modify({:ok, "big tune"}, "yeah", %{}) == {:ok, "big tune"}
    end

    test "allows error tuples to pass through" do
      assert Set.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
