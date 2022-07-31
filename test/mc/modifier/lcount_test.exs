defmodule Mc.Modifier.LcountTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Lcount

  describe "Mc.Modifier.Lcount.modify/2" do
    test "returns the number of lines in the `buffer`" do
      assert Lcount.modify("a few words", "n/a") == {:ok, "1"}
      assert Lcount.modify("1\nfoobar\n3", "n/a") == {:ok, "3"}
      assert Lcount.modify("\tnot for\nprofit", "n/a") == {:ok, "2"}
    end

    test "returns a help message" do
      assert Check.has_help?(Lcount, :modify)
    end

    test "errors with unknown switches" do
      assert Lcount.modify("n/a", "--unknown") == {:error, "Mc.Modifier.Lcount#modify: switch parse error"}
      assert Lcount.modify("", "-u") == {:error, "Mc.Modifier.Lcount#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Lcount.modify({:ok, "one\ntwo"}, "n/a") == {:ok, "2"}
    end

    test "allows error tuples to pass through" do
      assert Lcount.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
