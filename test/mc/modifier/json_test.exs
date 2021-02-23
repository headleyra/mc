defmodule Mc.Modifier.JsonTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Json

  describe "Mc.Modifier.Json.modify/2" do
    test "parses `buffer` as JSON and uses `args` as a hash 'key' or an array 'index'", do: true

    test "retrieves from a JSON object" do
      assert Json.modify(~s({"num":201}), "num") == {:ok, "201"}
      assert Json.modify(~s({"foo": "bar", "2": "oranges"}), "x") == {:ok, "null"}
      assert Json.modify(~s({"1": "apple"}), "") == {:ok, "null"}
    end

    test "retrieves from a JSON array" do
      assert Json.modify(~s(["bish", "foo", 25]), "2") == {:ok, "25"}
      assert Json.modify(~s([21]), "1") == {:ok, "null"}
      assert Json.modify(~s([2, "foo"]), "1") == {:ok, ~s("foo")}
    end

    test "retrieves from nested JSON" do
      json = """
      {
        "foo": [1, "2", 7],
        "biz": {
          "data": [3.142, "foo"]
        }
      }
      """
      assert Json.modify(json, "biz") == {:ok, ~s({"data":[3.142,"foo"]})}
      assert Json.modify(json, "foo") == {:ok, ~s([1,"2",7])}
      assert Json.modify("[[1, 2], 8]", "0") == {:ok, ~s([1,2])}
    end

    test "errors when the 'index' of the array is a non-integer" do
      assert Json.modify("[1, 2]", "wibble") == {:error, "Mc.Modifier.Json#modify: non integer JSON array index: wibble"}
    end

    test "errors when the JSON is malformed or the empty string" do
      assert Mc.Modifier.Json.modify(~s(oops!\"]), "0") == {:error, "Mc.Modifier.Json#modify: bad JSON"}
      assert Mc.Modifier.Json.modify("", "n/a") == {:error, "Mc.Modifier.Json#modify: bad JSON"}
    end

    test "errors for 'null' JSON" do
      assert Json.modify("null", "x") == {:error, "Mc.Modifier.Json#modify: null JSON"}
      assert Json.modify("null", "n/a") == {:error, "Mc.Modifier.Json#modify: null JSON"}
      assert Json.modify("null", "") == {:error, "Mc.Modifier.Json#modify: null JSON"}
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
      assert Json.modifya("[\"one\", 25]", "n/a") == {:ok, "\"one\"\n25"}
      assert Json.modifya("[2, 3.142]", "ignored") == {:ok, "2\n3.142"}
    end

    test "errors when the JSON isn't an array" do
      assert Json.modifya("{\"foo\":7}", "") == {:error, "Mc.Modifier.Json#modifya: expected a JSON array"}
      assert Json.modifya("{}", "ignored") == {:error, "Mc.Modifier.Json#modifya: expected a JSON array"}
      assert Json.modifya("null", "x") == {:error, "Mc.Modifier.Json#modifya: expected a JSON array"}
    end

    test "errors when the JSON is invalid" do
      assert Json.modifya("boom!\"]", "") == {:error, "Mc.Modifier.Json#modifya: bad JSON"}
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
      assert Json.list2el([2, "trois"], "nah") == {:error, "Mc.Modifier.Json#modify: non integer JSON array index: nah"}
      assert Json.list2el("n/a", "zero") == {:error, "Mc.Modifier.Json#modify: non integer JSON array index: zero"}
    end
  end
end
