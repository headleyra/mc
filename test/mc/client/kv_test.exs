defmodule Mc.Client.KvTest do
  use ExUnit.Case, async: false
  alias Mc.Client.Kv

  setup do
    start_supervised({Kv, map: %{"1st" => "foo", "2nd" => "foobar", "3rd" => "dosh"}})
    :ok
  end

  describe "Mc.Client.Kv.map/0" do
    test "returns the initial value of the map used for keys and values" do
      assert Kv.map() == %{"1st" => "foo", "2nd" => "foobar", "3rd" => "dosh"}
    end
  end

  describe "Mc.Client.Kv.set/2" do
    test "requests `value` is stored under `key` (and returns a value tuple)" do
      assert Kv.set("rand", "random\ndata") == {:ok, "random\ndata"}
      assert Kv.set("_x", "stuff") == {:ok, "stuff"}
    end
  end

  describe "Mc.Client.Kv.get/1" do
    test "retrieves the value stored under `key`" do
      Kv.set("a-key", "some buffer\ndata")

      assert Kv.get("a-key") == {:ok, "some buffer\ndata"}
      assert Kv.get("1st") == {:ok, "foo"}
      assert Kv.get("3rd") == {:ok, "dosh"}
    end

    test "returns empty string when the `key` doesn't exist" do
      assert Kv.get("key-no-exist") == {:ok, ""}
    end
  end

  describe "Mc.Client.Kv.findk/1" do
    test "finds keys matching its regex input" do
      assert Kv.findk("rd") == {:ok, "3rd"}
      assert Kv.findk("d") == {:ok, "2nd\n3rd"}
      assert Kv.findk("2") == {:ok, "2nd"}
      assert Kv.findk(".") == {:ok, "1st\n2nd\n3rd"}
      assert Kv.findk("") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when `regex` is bad" do
      assert Kv.findk("?") == {:error, "bad regex"}
      assert Kv.findk("*") == {:error, "bad regex"}
    end
  end

  describe "Mc.Client.Kv.findv/1" do
    test "finds values matching its regex input and returns their keys" do
      assert Kv.findv("os") == {:ok, "3rd"}
      assert Kv.findv("foo") == {:ok, "1st\n2nd"}
      assert Kv.findv("") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when `regex` is bad" do
      assert Kv.findv("?") == {:error, "bad regex"}
      assert Kv.findv("*") == {:error, "bad regex"}
    end
  end
end
