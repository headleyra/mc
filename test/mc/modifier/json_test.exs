defmodule Mc.Modifier.JsonTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Json

  describe "Mc.Modifier.Json.modify/2" do
    test "parses `buffer` as JSON and uses `args` to access it, returning a JSON array result", do: true

    test "accesses a JSON object" do
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

    test "returns empty string when the JSON is white space or empty string" do
      assert Mc.Modifier.Json.modify(" \t ", "n/a") == {:ok, ""}
      assert Mc.Modifier.Json.modify("", "n/a") == {:ok, ""}
    end

    test "returns empty string for 'null' JSON" do
      assert Json.modify("null", "x") == {:ok, ""}
      assert Json.modify("null", "") == {:ok, ""}
    end

    test "errors when an array 'index' is non-integer" do
      assert Json.modify("[1, 2]", "one") == {:error, "Mc.Modifier.Json#modify: non integer JSON array index"}
    end

    test "errors when the JSON is 'bad'" do
      assert Mc.Modifier.Json.modify(~s/oops!\"]/, "0") == {:error, "Mc.Modifier.Json#modify: bad JSON"}
    end

    test "accepts ok tuples" do
      assert Json.modify({:ok, "[20, 7]"}, "1") == {:ok, "7"}
    end

    test "allows error tuples to pass-through" do
      assert Json.modify({:error, "reason"}, "n/a") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Json.modifya/2" do
    test "converts a JSON array into a series of newline-separated strings" do
      assert Json.modifya(~s/["one", 25]/, "n/a") == {:ok, ~s/"one"\n25/}
      assert Json.modifya(~s/[{"a":1,"b":[2,"two"]}, 2, 3.1]/, "n/a") == {:ok, ~s/{"a":1,"b":[2,"two"]}\n2\n3.1/}
    end

    test "returns an empty string when the JSON isn't an array" do
      assert Json.modifya(~s/{"foo":7}/, "") == {:ok, ""}
      assert Json.modifya("{}", "ignored") == {:ok, ""}
      assert Json.modifya("null", "x") == {:ok, ""}
    end

    test "errors when the JSON is invalid" do
      assert Json.modifya(~s/boom!"]/, "") == {:error, "Mc.Modifier.Json#modifya: bad JSON"}
    end

    test "works with ok tuples" do
      assert Json.modifya({:ok, "[20, 7]"}, "n/a") == {:ok, "20\n7"}
    end

    test "allows error tuples to pass-through" do
      assert Json.modifya({:error, "reason"}, "n/a") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Json.list2el/2" do
    test "returns the element at the (string) 'index' given `list`, and then converts it to a string" do
      assert Json.list2el(["foo", 4], "1") == {:ok, "4"}
      assert Json.list2el([2, 4, "cars"], "2") == {:ok, "\"cars\""}
      assert Json.list2el([7, "cars"], "00") == {:ok, "7"}
    end

    test "errors given a non-integer 'index'" do
      assert Json.list2el([2, "trois"], "nah") == {:error, "Mc.Modifier.Json#modify: non integer JSON array index"}
      assert Json.list2el("n/a", "zero") == {:error, "Mc.Modifier.Json#modify: non integer JSON array index"}
    end
  end
end
