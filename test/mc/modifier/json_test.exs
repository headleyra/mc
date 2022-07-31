defmodule Mc.Modifier.JsonTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Json

  describe "Mc.Modifier.Json.modify/2" do
    test "parses `buffer` as JSON and uses `args` to access it (returning a JSON array result)" do
      assert Json.modify(~s/{"x":201}/, "x") == {:ok, "[201]"}
      assert Json.modify(~s/{"a":1, "b":2, "c":{"d":"four"}}/, "a c") == {:ok, ~s/[1,{"d":"four"}]/}
      assert Json.modify(~s/{"a":1, "b":2, "c":{"d":"four"}}/, "c a") == {:ok, ~s/[{"d":"four"},1]/}
      assert Json.modify(~s/{"x":4}/, "nah") == {:ok, ~s/[null]/}
      assert Json.modify(~s/{"prime":5,"pi":3.142,"e":2.718}/, "x y") == {:ok, ~s/[null,null]/}
      assert Json.modify(~s/{"foo": "bar", "2": "oranges"}/, "x") == {:ok, "[null]"}
      assert Json.modify(~s/{"1":"apple"}/, " \t ") == {:ok, "[]"}
      assert Json.modify(~s/{"1":"oranges"}/, "") == {:ok, "[]"}
    end

    test "accesses a JSON array" do
      assert Json.modify(~s/["bish", "foo", 25]/, "2") == {:ok, "25"}
      assert Json.modify(~s/["foo", 2]/, "0") == {:ok, ~s/"foo"/}
      assert Json.modify(~s/[21.7]/, "1") == {:ok, "null"}
    end

    test "returns empty string for 'null' JSON" do
      assert Json.modify("null", "x") == {:ok, ""}
      assert Json.modify("null", "") == {:ok, ""}
    end

    test "errors when an array 'index' is not an integer (>= 0)" do
      assert Json.modify("[1, 2]", "one") == {:error, "Mc.Modifier.Json#modify: array index should be >= 0"}
      assert Json.modify("[1, 2]", "-1") == {:error, "Mc.Modifier.Json#modify: array index should be >= 0"}
      assert Json.modify("[1, 2]", "3.142") == {:error, "Mc.Modifier.Json#modify: array index should be >= 0"}
      assert Json.modify("[1, 2]", "!") == {:error, "Mc.Modifier.Json#modify: array index should be >= 0"}
    end

    test "errors when the JSON is 'bad'" do
      assert Mc.Modifier.Json.modify(~s/oops!\"]/, "0") == {:error, "Mc.Modifier.Json#modify: bad JSON"}
      assert Mc.Modifier.Json.modify(" \t ", "") == {:error, "Mc.Modifier.Json#modify: bad JSON"}
      assert Mc.Modifier.Json.modify("", "") == {:error, "Mc.Modifier.Json#modify: bad JSON"}
    end

    test "converts a JSON array into a series of newline-separated strings ('array' switch)" do
      assert Json.modify(~s/["one", 25]/, "--array") == {:ok, ~s/"one"\n25/}
      assert Json.modify(~s/[{"a":1,"b":[2,"two"]}, 2, 3.1]/, "-a") == {:ok, ~s/{"a":1,"b":[2,"two"]}\n2\n3.1/}
    end

    test "returns an empty string when the JSON isn't an array ('array' switch)" do
      assert Json.modify(~s/{"foo":7}/, "-a") == {:ok, ""}
      assert Json.modify("{}", "-a") == {:ok, ""}
      assert Json.modify("null", "-a") == {:ok, ""}
    end

    test "errors when the JSON is invalid ('array' switch)" do
      assert Json.modify(~s/boom!"]/, "-a") == {:error, "Mc.Modifier.Json#modify: bad JSON"}
    end

    test "returns a help message" do
      assert Check.has_help?(Json, :modify)
    end

    test "errors with unknown switches" do
      assert Json.modify("", "--unknown") == {:error, "Mc.Modifier.Json#modify: switch parse error"}
      assert Json.modify("", "-u") == {:error, "Mc.Modifier.Json#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Json.modify({:ok, "[20, 7]"}, "1") == {:ok, "7"}
      assert Json.modify({:ok, "[20, 7]"}, "-a") == {:ok, "20\n7"}
    end

    test "allows error tuples to pass through" do
      assert Json.modify({:error, "reason"}, "") == {:error, "reason"}
      assert Json.modify({:error, "reason"}, "-a") == {:error, "reason"}
    end
  end
end
