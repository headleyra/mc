defmodule Mc.Modifier.FindKTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.FindK

  setup do
    map = %{"1st" => "foo", "2nd" => "foobar", "3rd" => "dosh"}
    start_supervised({Mc.Adapter.KvMemory, map: map})
    :ok
  end

  describe "m/3" do
    test "finds keys matching the given regex" do
      assert FindK.m("n/a", "rd", %{}) == {:ok, "3rd"}
      assert FindK.m("", "d", %{}) == {:ok, "2nd\n3rd"}
      assert FindK.m("", ".", %{}) == {:ok, "1st\n2nd\n3rd"}
      assert FindK.m("", "", %{}) == {:ok, "1st\n2nd\n3rd"}
    end

    test "returns emtpy string when key is not found" do
      assert FindK.m("", "this-key-wont-be-found", %{}) == {:ok, ""}
    end

    test "errors when the regex is bad" do
      assert FindK.m("", "?", %{}) == {:error, "Mc.Modifier.FindK: bad regex"}
    end

    test "works with ok tuples" do
      assert FindK.m({:ok, "n/a"}, "2", %{}) == {:ok, "2nd"}
    end

    test "allows error tuples to pass through" do
      assert FindK.m({:error, "reason"}, "key", %{}) == {:error, "reason"}
    end
  end
end
