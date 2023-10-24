defmodule Mc.Adapter.KvMemoryTest do
  use ExUnit.Case, async: true
  alias Mc.Adapter.KvMemory

  setup do
    map =
      %{
        "1st" => "foo",
        "2nd" => "foobar",
        "3rd" => "dosh"
      }

    start_supervised({KvMemory, map: map})
    :ok
  end

  describe "set/2" do
    test "requests `value` is stored under `key` (returns value)" do
      assert KvMemory.set("rand", "random\ndata") == {:ok, "random\ndata"}
      assert KvMemory.set("_x", "stuff") == {:ok, "stuff"}
    end
  end

  describe "get/1" do
    test "retrieves the value stored under `key`" do
      KvMemory.set("a-key", "some buffer\ndata")

      assert KvMemory.get("a-key") == {:ok, "some buffer\ndata"}
      assert KvMemory.get("1st") == {:ok, "foo"}
      assert KvMemory.get("3rd") == {:ok, "dosh"}
    end

    test "returns 'not found' when the `key` doesn't exist" do
      assert KvMemory.get("key-no-exist") == {:error, "not found"}
    end
  end

  describe "findk/1" do
    test "finds keys matching its regex input" do
      assert KvMemory.findk("rd") == {:ok, "3rd"}
      assert KvMemory.findk("d") == {:ok, "2nd\n3rd"}
      assert KvMemory.findk("2") == {:ok, "2nd"}
      assert KvMemory.findk(".") == {:ok, "1st\n2nd\n3rd"}
      assert KvMemory.findk("") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when `regex` is bad" do
      assert KvMemory.findk("?") == {:error, "bad regex"}
      assert KvMemory.findk("*") == {:error, "bad regex"}
    end
  end

  describe "findv/1" do
    test "finds values matching its regex input and returns their keys" do
      assert KvMemory.findv("os") == {:ok, "3rd"}
      assert KvMemory.findv("foo") == {:ok, "1st\n2nd"}
      assert KvMemory.findv("") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when `regex` is bad" do
      assert KvMemory.findv("?") == {:error, "bad regex"}
      assert KvMemory.findv("*") == {:error, "bad regex"}
    end
  end
end
