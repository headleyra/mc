defmodule Mc.Modifier.GetTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Get

  setup do
    map = %{
      "funky" => "dance",
      "a-key" => "some\ndata"
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    :ok
  end

  describe "m/3" do
    test "gets the value stored under the given key" do
      assert Get.m("", "a-key", %{}) == {:ok, "some\ndata"}
    end

    test "errors when the key doesn't exist" do
      assert Get.m("", "no-exist", %{}) == {:error, Mc.Modifier.Get, :key_not_found, "no-exist", []}
    end

    test "works with ok-tuples" do
      assert Get.m({:ok, "n/a"}, "funky", %{}) == {:ok, "dance"}
      assert Get.m({:ok, ""}, "bop", %{}) == {:error, Mc.Modifier.Get, :key_not_found, "bop", []}
    end

    test "allows error-tuples to pass through" do
      assert Get.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
