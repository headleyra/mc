defmodule Mc.Adapter.KvMemoryTest do
  use ExUnit.Case, async: false
  alias Mc.Adapter.KvMemory

  setup do
    map =
      %{
        "1st" => "foo",
        "2nd" => "foobar",
        "3rd" => "dosh",
        "4th" => "first: Sam\nlast: Phox",
        "5th" => "first: Bob\nlast: Builder"
      }

    start_supervised({KvMemory, map: map})
    :ok
  end

  describe "set/2" do
    test "requests `value` is stored under `key` and returns `value`" do
      assert KvMemory.set("rand", "random\ndata") == {:ok, "random\ndata"}
      assert KvMemory.set("_x", "stuff") == {:ok, "stuff"}
    end
  end

  describe "get/1" do
    test "returns the value stored under `key`" do
      KvMemory.set("a-key", "some buffer\ndata")
      assert KvMemory.get("a-key") == {:ok, "some buffer\ndata"}
      assert KvMemory.get("1st") == {:ok, "foo"}
      assert KvMemory.get("3rd") == {:ok, "dosh"}
    end

    test "errors when the `key` doesn't exist" do
      assert KvMemory.get("key-no-exist") == {:error, :not_found}
    end
  end

  describe "findk/1" do
    test "finds keys matching `regex`" do
      assert KvMemory.findk("rd") == {:ok, "3rd"}
      assert KvMemory.findk("d") == {:ok, "2nd\n3rd"}
      assert KvMemory.findk("2") == {:ok, "2nd"}
      assert KvMemory.findk(".") == {:ok, "1st\n2nd\n3rd\n4th\n5th"}
      assert KvMemory.findk("") == {:ok, "1st\n2nd\n3rd\n4th\n5th"}
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
      assert KvMemory.findv("") == {:ok, "1st\n2nd\n3rd\n4th\n5th"}
      assert KvMemory.findv("^last:") == {:ok, "4th\n5th"}
      assert KvMemory.findv("Sam$") == {:ok, "4th"}
      assert KvMemory.findv("Builder$") == {:ok, "5th"}
    end

    test "errors when `regex` is bad" do
      assert KvMemory.findv("?") == {:error, "bad regex"}
      assert KvMemory.findv("*") == {:error, "bad regex"}
    end
  end

  describe "delete/1" do
    test "deletes its key and returns 1" do
      KvMemory.set("delly", "old data")
      assert KvMemory.get("delly") == {:ok, "old data"}
      assert KvMemory.delete("delly") == 1
      assert KvMemory.get("delly") == {:error, :not_found}
    end

    test "returns 0 when it thinks (i.e., ignoring potential race conditions) the key doesn't exist" do
      assert KvMemory.delete("no-exist-key-foo-bar-biz") == 0
    end
  end
end
