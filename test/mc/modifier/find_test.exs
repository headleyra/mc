defmodule Mc.Modifier.FindTest do
  use ExUnit.Case, async: false
  alias Mc.Client.Kv.Memory
  alias Mc.Modifier.Find

  setup do
    start_supervised({Memory, map: %{"1st" => "foo", "2nd" => "foobar", "3rd" => "dosh"}})
    start_supervised({Find, kv_client: Memory})
    :ok
  end

  describe "Mc.Modifier.Find.kv_client/0" do
    test "returns the KV client implementation" do
      assert Find.kv_client() == Memory
    end
  end

  describe "Mc.Modifier.Find.modify/2" do
    test "finds keys matching the given regex" do
      assert Find.modify("n/a", "rd") == {:ok, "3rd"}
      assert Find.modify("", "d") == {:ok, "2nd\n3rd"}
      assert Find.modify("", ".") == {:ok, "1st\n2nd\n3rd"}
      assert Find.modify("", "") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when the regex is bad" do
      assert Find.modify("", "?") == {:error, "Mc.Modifier.Find#modify: bad regex"}
    end

    test "works with ok tuples" do
      assert Find.modify({:ok, "n/a"}, "2") == {:ok, "2nd"}
    end

    test "allows error tuples to pass through" do
      assert Find.modify({:error, "reason"}, "key") == {:error, "reason"}
    end
  end
end
