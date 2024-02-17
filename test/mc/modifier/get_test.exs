defmodule Mc.Modifier.GetTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Get

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{}})
    :ok
  end

  describe "modify/3" do
    test "gets the value stored under the given key" do
      Mc.Modifier.Set.modify("some buffer\ndata", "a-key", %{})
      assert Get.modify("", "a-key", %{}) == {:ok, "some buffer\ndata"}
    end

    test "errors when the key doesn't exist" do
      assert Get.modify("", "no-exist", %{}) == {:error, "Mc.Modifier.Get: not found: no-exist"}
    end

    test "works with ok tuples" do
      Mc.Modifier.Set.modify("dance", "funky", %{})
      assert Get.modify({:ok, "n/a"}, "funky", %{}) == {:ok, "dance"}
      assert Get.modify({:ok, ""}, "bop", %{}) == {:error, "Mc.Modifier.Get: not found: bop"}
    end

    test "allows error tuples to pass through" do
      assert Get.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
