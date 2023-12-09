defmodule Mc.Modifier.JsonaTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Jsona

  describe "modify/3" do
    test "parses `buffer` as a JSON array and returns a series of newline-separated strings" do
      assert Jsona.modify(~s/["one", 25]/, "", %{}) == {:ok, ~s/"one"\n25/}
      assert Jsona.modify(~s/[{"a":1,"b":[2,"two"]}, 2, 3.1]/, "", %{}) == {:ok, ~s/{"a":1,"b":[2,"two"]}\n2\n3.1/}
    end

    test "returns an empty string when the JSON isn't an array ('array' switch)" do
      assert Jsona.modify(~s/{"foo":7}/, "", %{}) == {:ok, ""}
      assert Jsona.modify("{}", "", %{}) == {:ok, ""}
      assert Jsona.modify("null", "", %{}) == {:ok, ""}
    end

    test "errors when the JSON is invalid ('array' switch)" do
      assert Jsona.modify(~s/boom!"]/, "", %{}) == {:error, "Mc.Modifier.Jsona#modify: bad JSON"}
    end

    test "works with ok tuples" do
      assert Jsona.modify({:ok, "[20, 7]"}, "", %{}) == {:ok, "20\n7"}
    end

    test "allows error tuples to pass through" do
      assert Jsona.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
