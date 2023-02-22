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

    start_supervised({KvMemory, map: map, name: :cash})
    :ok
  end

  describe "set/3" do
    test "requests `value` is stored under `key` (returns value)" do
      assert KvMemory.set(:cash, "rand", "random\ndata") == {:ok, "random\ndata"}
      assert KvMemory.set(:cash, "_x", "stuff") == {:ok, "stuff"}
    end
  end

  describe "get/2" do
    test "retrieves the value stored under `key`" do
      KvMemory.set(:cash, "a-key", "some buffer\ndata")

      assert KvMemory.get(:cash, "a-key") == {:ok, "some buffer\ndata"}
      assert KvMemory.get(:cash, "1st") == {:ok, "foo"}
      assert KvMemory.get(:cash, "3rd") == {:ok, "dosh"}
    end

    test "returns empty string when the `key` doesn't exist" do
      assert KvMemory.get(:cash, "key-no-exist") == {:ok, ""}
    end
  end

  describe "findk/2" do
    test "finds keys matching its regex input" do
      assert KvMemory.findk(:cash, "rd") == {:ok, "3rd"}
      assert KvMemory.findk(:cash, "d") == {:ok, "2nd\n3rd"}
      assert KvMemory.findk(:cash, "2") == {:ok, "2nd"}
      assert KvMemory.findk(:cash, ".") == {:ok, "1st\n2nd\n3rd"}
      assert KvMemory.findk(:cash, "") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when `regex` is bad" do
      assert KvMemory.findk(:cash, "?") == {:error, "bad regex"}
      assert KvMemory.findk(:cash, "*") == {:error, "bad regex"}
    end
  end

  describe "findv/1" do
    test "finds values matching its regex input and returns their keys" do
      assert KvMemory.findv(:cash, "os") == {:ok, "3rd"}
      assert KvMemory.findv(:cash, "foo") == {:ok, "1st\n2nd"}
      assert KvMemory.findv(:cash, "") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when `regex` is bad" do
      assert KvMemory.findv(:cash, "?") == {:error, "bad regex"}
      assert KvMemory.findv(:cash, "*") == {:error, "bad regex"}
    end
  end
end
