defmodule Mc.Client.Kv.MemoryTest do
  use ExUnit.Case, async: true
  alias Mc.Client.Kv.Memory

  setup do
    map = %{"1st" => "foo", "2nd" => "foobar", "3rd" => "dosh"}
    start_supervised({Memory, map: map, name: :cash})
    :ok
  end

  describe "Mc.Client.Kv.Memory.map/1" do
    test "returns the initial value of the KV map" do
      assert Memory.map(:cash) == %{"1st" => "foo", "2nd" => "foobar", "3rd" => "dosh"}
    end
  end

  describe "Mc.Client.Kv.Memory.set/3" do
    test "requests `value` is stored under `key` (and returns value)" do
      assert Memory.set(:cash, "rand", "random\ndata") == {:ok, "random\ndata"}
      assert Memory.set(:cash, "_x", "stuff") == {:ok, "stuff"}
    end
  end

  describe "Mc.Client.Kv.Memory.get/2" do
    test "retrieves the value stored under `key`" do
      Memory.set(:cash, "a-key", "some buffer\ndata")

      assert Memory.get(:cash, "a-key") == {:ok, "some buffer\ndata"}
      assert Memory.get(:cash, "1st") == {:ok, "foo"}
      assert Memory.get(:cash, "3rd") == {:ok, "dosh"}
    end

    test "returns empty string when the `key` doesn't exist" do
      assert Memory.get(:cash, "key-no-exist") == {:ok, ""}
    end
  end

  describe "Mc.Client.Kv.Memory.findk/2" do
    test "finds keys matching its regex input" do
      assert Memory.findk(:cash, "rd") == {:ok, "3rd"}
      assert Memory.findk(:cash, "d") == {:ok, "2nd\n3rd"}
      assert Memory.findk(:cash, "2") == {:ok, "2nd"}
      assert Memory.findk(:cash, ".") == {:ok, "1st\n2nd\n3rd"}
      assert Memory.findk(:cash, "") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when `regex` is bad" do
      assert Memory.findk(:cash, "?") == {:error, "bad regex"}
      assert Memory.findk(:cash, "*") == {:error, "bad regex"}
    end
  end

  describe "Mc.Client.Kv.Memory.findv/1" do
    test "finds values matching its regex input and returns their keys" do
      assert Memory.findv(:cash, "os") == {:ok, "3rd"}
      assert Memory.findv(:cash, "foo") == {:ok, "1st\n2nd"}
      assert Memory.findv(:cash, "") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when `regex` is bad" do
      assert Memory.findv(:cash, "?") == {:error, "bad regex"}
      assert Memory.findv(:cash, "*") == {:error, "bad regex"}
    end
  end
end
