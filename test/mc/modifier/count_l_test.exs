defmodule Mc.Modifier.CountLTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.CountL

  describe "modify/3" do
    test "returns the number of lines in the `buffer`" do
      assert CountL.modify("a few words", "n/a", %{}) == {:ok, "1"}
      assert CountL.modify("1\nfoobar\n3", "n/a", %{}) == {:ok, "3"}
      assert CountL.modify("\tnot for\nprofit", "n/a", %{}) == {:ok, "2"}
    end

    test "works with ok tuples" do
      assert CountL.modify({:ok, "one\ntwo"}, "n/a", %{}) == {:ok, "2"}
    end

    test "allows error tuples to pass through" do
      assert CountL.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
