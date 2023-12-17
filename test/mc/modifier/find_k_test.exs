defmodule Mc.Modifier.FindKTest do
  use ExUnit.Case, async: false
  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.FindK

  setup do
    map = %{"1st" => "foo", "2nd" => "foobar", "3rd" => "dosh"}
    start_supervised({KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    test "finds keys matching the given regex" do
      assert FindK.modify("n/a", "rd", %{}) == {:ok, "3rd"}
      assert FindK.modify("", "d", %{}) == {:ok, "2nd\n3rd"}
      assert FindK.modify("", ".", %{}) == {:ok, "1st\n2nd\n3rd"}
      assert FindK.modify("", "", %{}) == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when the regex is bad" do
      assert FindK.modify("", "?", %{}) == {:error, "Mc.Modifier.FindK: bad regex"}
    end

    test "works with ok tuples" do
      assert FindK.modify({:ok, "n/a"}, "2", %{}) == {:ok, "2nd"}
    end

    test "allows error tuples to pass through" do
      assert FindK.modify({:error, "reason"}, "key", %{}) == {:error, "reason"}
    end
  end
end
