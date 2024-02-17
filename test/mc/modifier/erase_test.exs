defmodule Mc.Modifier.EraseTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Erase

  setup do
    map = %{
      "delly" => "old data"
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    test "deletes its key and returns 1" do
      assert Mc.Modifier.Get.modify("", "delly", %{}) == {:ok, "old data"}
      assert Erase.modify("", "delly", %{}) == {:ok, "1"}
      assert Mc.Modifier.Get.modify("", "delly", %{}) == {:error, "Mc.Modifier.Get: not found: delly"}
    end

    test "returns 0 when its key doesn't exist" do
      assert Erase.modify("n/a", "key-no-exist-foo-bar", %{}) == {:ok, "0"}
    end

    test "works with ok tuples" do
      assert Mc.Modifier.Get.modify("", "delly", %{}) == {:ok, "old data"}
      assert Erase.modify({:ok, "n/a"}, "delly", %{}) == {:ok, "1"}
      assert Mc.Modifier.Get.modify("", "delly", %{}) == {:error, "Mc.Modifier.Get: not found: delly"}
      assert Erase.modify({:ok, ""}, "no-exist-abc", %{}) == {:ok, "0"}
    end

    test "allows error tuples to pass through" do
      assert Erase.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
