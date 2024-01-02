defmodule Mc.Modifier.FindVTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.FindV

  setup do
    map = %{
      "1st" => "foo",
      "2nd" => "foobar",
      "3rd" => "dosh"
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    test "finds keys with values matching the given regex" do
      assert FindV.modify("n/a", "os", %{}) == {:ok, "3rd"}
      assert FindV.modify("", "foo", %{}) == {:ok, "1st\n2nd"}
      assert FindV.modify("", "", %{}) == {:ok, "1st\n2nd\n3rd"}
    end

    test "returns empty string when searches are unsuccessful" do
      assert FindV.modify("", "this-wont-be-found", %{}) == {:ok, ""}
    end

    test "errors when the regex is bad" do
      assert FindV.modify("", "*", %{}) == {:error, "Mc.Modifier.FindV: bad regex"}
    end

    test "works with ok tuples" do
      assert FindV.modify({:ok, "n/a"}, "foo", %{}) == {:ok, "1st\n2nd"}
    end

    test "allows error tuples to pass through" do
      assert FindV.modify({:error, "reason"}, "key", %{}) == {:error, "reason"}
    end
  end
end
