defmodule Mc.Modifier.CountWTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.CountW

  describe "modify/3" do
    test "returns the number of words in the `buffer`" do
      assert CountW.modify("un deux trois", "n/a", %{}) == {:ok, "3"}
      assert CountW.modify("\t\tfoobar\nbiz\n\n", "n/a", %{}) == {:ok, "2"}
      assert CountW.modify("not      for\nprofit", "n/a", %{}) == {:ok, "3"}
    end

    test "works with ok tuples" do
      assert CountW.modify({:ok, "why not best\nof seven?"}, "n/a", %{}) == {:ok, "5"}
    end

    test "allows error tuples to pass through" do
      assert CountW.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
