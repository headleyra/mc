defmodule Mc.Modifier.GetTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Get

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{}})
    :ok
  end

  describe "m/3" do
    test "gets the value stored under the given key" do
      Mc.Modifier.Set.m("some buffer\ndata", "a-key", %{})
      assert Get.m("", "a-key", %{}) == {:ok, "some buffer\ndata"}
    end

    test "errors when the key doesn't exist" do
      assert Get.m("", "no-exist", %{}) == {:error, "Mc.Modifier.Get: not found: no-exist"}
    end

    test "works with ok tuples" do
      Mc.Modifier.Set.m("dance", "funky", %{})
      assert Get.m({:ok, "n/a"}, "funky", %{}) == {:ok, "dance"}
      assert Get.m({:ok, ""}, "bop", %{}) == {:error, "Mc.Modifier.Get: not found: bop"}
    end

    test "allows error tuples to pass through" do
      assert Get.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
