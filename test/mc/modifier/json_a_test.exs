defmodule Mc.Modifier.JsonATest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.JsonA

  describe "m/3" do
    test "parses `buffer` as a JSON array and returns a series of newline-separated strings" do
      assert JsonA.m(~s/["one", 25]/, "", %{}) == {:ok, ~s/"one"\n25/}
      assert JsonA.m(~s/[{"a":1,"b":[2,"two"]}, 2, 3.1]/, "", %{}) == {:ok, ~s/{"a":1,"b":[2,"two"]}\n2\n3.1/}
    end

    test "returns an empty string when the JSON isn't an array" do
      assert JsonA.m(~s/{"foo":7}/, "", %{}) == {:ok, ""}
      assert JsonA.m("{}", "", %{}) == {:ok, ""}
      assert JsonA.m("null", "", %{}) == {:ok, ""}
    end

    test "errors with bad JSON" do
      assert JsonA.m(~s/boom!"]/, "", %{}) == {:error, Mc.Modifier.JsonA, :bad_json, ~s/boom!"]/, []}
    end

    test "works with ok-tuples" do
      assert JsonA.m({:ok, "[20, 7]"}, "", %{}) == {:ok, "20\n7"}
    end

    test "allows error-tuples to pass through" do
      assert JsonA.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
