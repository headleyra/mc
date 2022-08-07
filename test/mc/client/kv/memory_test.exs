defmodule Mc.Client.Kv.MemoryTest do
  use ExUnit.Case, async: false
  alias Mc.Client.Kv.Memory

  setup do
    start_supervised({Memory, map: %{"1st" => "foo", "2nd" => "foobar", "3rd" => "dosh"}})
    :ok
  end

  describe "Mc.Client.Kv.Memory.map/0" do
    test "returns the initial value of the map used for keys and values" do
      assert Memory.map() == %{"1st" => "foo", "2nd" => "foobar", "3rd" => "dosh"}
    end
  end

  describe "Mc.Client.Kv.Memory.set/2" do
    test "requests `value` is stored under `key` (and returns a value tuple)" do
      assert Memory.set("rand", "random\ndata") == {:ok, "random\ndata"}
      assert Memory.set("_x", "stuff") == {:ok, "stuff"}
    end
  end

  describe "Mc.Client.Kv.Memory.get/1" do
    test "retrieves the value stored under `key`" do
      Memory.set("a-key", "some buffer\ndata")

      assert Memory.get("a-key") == {:ok, "some buffer\ndata"}
      assert Memory.get("1st") == {:ok, "foo"}
      assert Memory.get("3rd") == {:ok, "dosh"}
    end

    test "returns empty string when the `key` doesn't exist" do
      assert Memory.get("key-no-exist") == {:ok, ""}
    end
  end

  describe "Mc.Client.Kv.Memory.findk/1" do
    test "finds keys matching its regex input" do
      assert Memory.findk("rd") == {:ok, "3rd"}
      assert Memory.findk("d") == {:ok, "2nd\n3rd"}
      assert Memory.findk("2") == {:ok, "2nd"}
      assert Memory.findk(".") == {:ok, "1st\n2nd\n3rd"}
      assert Memory.findk("") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when `regex` is bad" do
      assert Memory.findk("?") == {:error, "bad regex"}
      assert Memory.findk("*") == {:error, "bad regex"}
    end
  end

  describe "Mc.Client.Kv.Memory.findv/1" do
    test "finds values matching its regex input and returns their keys" do
      assert Memory.findv("os") == {:ok, "3rd"}
      assert Memory.findv("foo") == {:ok, "1st\n2nd"}
      assert Memory.findv("") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when `regex` is bad" do
      assert Memory.findv("?") == {:error, "bad regex"}
      assert Memory.findv("*") == {:error, "bad regex"}
    end
  end
end
