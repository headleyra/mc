defmodule Mc.Modifier.FindvTest do
  use ExUnit.Case, async: false
  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.Findv

  setup do
    map = %{"1st" => "foo", "2nd" => "foobar", "3rd" => "dosh"}
    start_supervised({KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    test "finds keys with values matching the given regex" do
      assert Findv.modify("n/a", "os", %{}) == {:ok, "3rd"}
      assert Findv.modify("", "foo", %{}) == {:ok, "1st\n2nd"}
      assert Findv.modify("", "", %{}) == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when the regex is bad" do
      assert Findv.modify("", "*", %{}) == {:error, "Mc.Modifier.Findv: bad regex"}
    end

    test "works with ok tuples" do
      assert Findv.modify({:ok, "n/a"}, "foo", %{}) == {:ok, "1st\n2nd"}
    end

    test "allows error tuples to pass through" do
      assert Findv.modify({:error, "reason"}, "key", %{}) == {:error, "reason"}
    end
  end
end
