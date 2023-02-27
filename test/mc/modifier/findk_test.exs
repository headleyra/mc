defmodule Mc.Modifier.FindkTest do
  use ExUnit.Case, async: false
  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.Findk

  setup do
    map = %{"1st" => "foo", "2nd" => "foobar", "3rd" => "dosh"}
    start_supervised({KvMemory, map: map})
    :ok
  end

  describe "modify/2" do
    test "finds keys matching the given regex" do
      assert Findk.modify("n/a", "rd") == {:ok, "3rd"}
      assert Findk.modify("", "d") == {:ok, "2nd\n3rd"}
      assert Findk.modify("", ".") == {:ok, "1st\n2nd\n3rd"}
      assert Findk.modify("", "") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when the regex is bad" do
      assert Findk.modify("", "?") == {:error, "Mc.Modifier.Findk#modify: bad regex"}
    end

    test "works with ok tuples" do
      assert Findk.modify({:ok, "n/a"}, "2") == {:ok, "2nd"}
    end

    test "allows error tuples to pass through" do
      assert Findk.modify({:error, "reason"}, "key") == {:error, "reason"}
    end
  end
end
