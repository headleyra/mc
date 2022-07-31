defmodule Mc.Modifier.WcountTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Wcount

  describe "Mc.Modifier.Wcount.modify/2" do
    test "returns the number of words in the `buffer`" do
      assert Wcount.modify("un deux trois", "n/a") == {:ok, "3"}
      assert Wcount.modify("\t\tfoobar\nbiz\n\n", "n/a") == {:ok, "2"}
      assert Wcount.modify("not      for\nprofit", "n/a") == {:ok, "3"}
    end

    test "returns a help message" do
      assert Check.has_help?(Wcount, :modify)
    end

    test "errors with unknown switches" do
      assert Wcount.modify("n/a", "--unknown") == {:error, "Mc.Modifier.Wcount#modify: switch parse error"}
      assert Wcount.modify("", "-u") == {:error, "Mc.Modifier.Wcount#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Wcount.modify({:ok, "why not best\nof seven?"}, "n/a") == {:ok, "5"}
    end

    test "allows error tuples to pass through" do
      assert Wcount.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
