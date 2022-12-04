defmodule Mc.Modifier.GetTest do
  use ExUnit.Case, async: false
  alias Mc.Client.Kv.Memory
  alias Mc.Modifier.Set
  alias Mc.Modifier.Get

  setup do
    start_supervised({Memory, map: %{}, name: :cache})
    start_supervised({Set, kv_client: Memory, kv_pid: :cache})
    start_supervised({Get, kv_client: Memory, kv_pid: :cache})
    :ok
  end

  describe "Mc.Modifier.Get.modify/2" do
    test "returns the KV client implementation" do
      assert Get.kv_client() == Memory
    end

    test "returns the KV client pid" do
      assert Get.kv_pid() == :cache
    end

    test "retrieves the value stored under the given key" do
      Set.modify("some buffer\ndata", "a-key")
      assert Get.modify("", "a-key") == {:ok, "some buffer\ndata"}
    end

    test "returns empty string when the key doesn't exist" do
      assert Get.modify("", "key-no-exist") == {:ok, ""}
    end

    test "works with ok tuples" do
      Set.modify("dance", "funky")
      assert Get.modify({:ok, "n/a"}, "funky") == {:ok, "dance"}
      assert Get.modify({:ok, ""}, "bop") == {:ok, ""}
    end

    test "allows error tuples to pass through" do
      assert Get.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
