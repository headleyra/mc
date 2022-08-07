defmodule Mc.Modifier.SetTest do
  use ExUnit.Case, async: false
  alias Mc.Client.Kv.Memory
  alias Mc.Modifier.Set

  setup do
    start_supervised({Memory, map: %{}})
    start_supervised({Set, kv_client: Memory})
    :ok
  end

  describe "Mc.Modifier.Set.modify/2" do
    test "returns the KV client implementation" do
      assert Set.kv_client() == Memory
    end

    test "stores `buffer` under the given key and returns `buffer`" do
      assert Set.modify("random data", "rand") == {:ok, "random data"}
      assert Set.modify("stuff", "_x") == {:ok, "stuff"}
    end

    test "returns a help message" do
      assert Check.has_help?(Set, :modify)
    end

    test "errors with unknown switches" do
      assert Set.modify("", "--unknown") == {:error, "Mc.Modifier.Set#modify: switch parse error"}
      assert Set.modify("", "-u") == {:error, "Mc.Modifier.Set#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Set.modify({:ok, "big tune"}, "yeah") == {:ok, "big tune"}
    end

    test "allows error tuples to pass through" do
      assert Set.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
