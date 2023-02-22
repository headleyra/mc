defmodule Mc.Modifier.LcountTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Lcount

  describe "modify/2" do
    test "returns the number of lines in the `buffer`" do
      assert Lcount.modify("a few words", "n/a") == {:ok, "1"}
      assert Lcount.modify("1\nfoobar\n3", "n/a") == {:ok, "3"}
      assert Lcount.modify("\tnot for\nprofit", "n/a") == {:ok, "2"}
    end

    test "works with ok tuples" do
      assert Lcount.modify({:ok, "one\ntwo"}, "n/a") == {:ok, "2"}
    end

    test "allows error tuples to pass through" do
      assert Lcount.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
