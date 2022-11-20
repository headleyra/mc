defmodule Mc.Modifier.FindvTest do
  use ExUnit.Case, async: false
  alias Mc.Client.Kv.Memory
  alias Mc.Modifier.Findv

  setup do
    start_supervised({Memory, map: %{"1st" => "foo", "2nd" => "foobar", "3rd" => "dosh"}})
    start_supervised({Findv, kv_client: Memory})
    :ok
  end

  describe "Mc.Modifier.Findv.kv_client/0" do
    test "returns the KV client implementation" do
      assert Findv.kv_client() == Memory
    end
  end

  describe "Mc.Modifier.Findv.modify/2" do
    test "finds keys with values matching the given regex" do
      assert Findv.modify("n/a", "os") == {:ok, "3rd"}
      assert Findv.modify("", "foo") == {:ok, "1st\n2nd"}
      assert Findv.modify("", "") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when the regex is bad" do
      assert Findv.modify("", "*") == {:error, "Mc.Modifier.Findv#modify: bad regex"}
    end

    test "works with ok tuples" do
      assert Findv.modify({:ok, "n/a"}, "foo") == {:ok, "1st\n2nd"}
    end

    test "allows error tuples to pass through" do
      assert Findv.modify({:error, "reason"}, "key") == {:error, "reason"}
    end
  end
end