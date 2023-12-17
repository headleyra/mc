defmodule Mc.Modifier.JsonATest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.JsonA

  describe "modify/3" do
    test "parses `buffer` as a JSON array and returns a series of newline-separated strings" do
      assert JsonA.modify(~s/["one", 25]/, "", %{}) == {:ok, ~s/"one"\n25/}
      assert JsonA.modify(~s/[{"a":1,"b":[2,"two"]}, 2, 3.1]/, "", %{}) == {:ok, ~s/{"a":1,"b":[2,"two"]}\n2\n3.1/}
    end

    test "returns an empty string when the JSON isn't an array ('array' switch)" do
      assert JsonA.modify(~s/{"foo":7}/, "", %{}) == {:ok, ""}
      assert JsonA.modify("{}", "", %{}) == {:ok, ""}
      assert JsonA.modify("null", "", %{}) == {:ok, ""}
    end

    test "errors when the JSON is invalid ('array' switch)" do
      assert JsonA.modify(~s/boom!"]/, "", %{}) == {:error, "Mc.Modifier.JsonA: bad JSON"}
    end

    test "works with ok tuples" do
      assert JsonA.modify({:ok, "[20, 7]"}, "", %{}) == {:ok, "20\n7"}
    end

    test "allows error tuples to pass through" do
      assert JsonA.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
