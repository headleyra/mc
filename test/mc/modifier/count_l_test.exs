defmodule Mc.Modifier.CountLTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.CountL

  describe "m/3" do
    test "returns the number of lines in the `buffer`" do
      assert CountL.m("a few words", "n/a", %{}) == {:ok, "1"}
      assert CountL.m("1\nfoobar\n3", "", %{}) == {:ok, "3"}
      assert CountL.m("\tnot for\nprofit", "", %{}) == {:ok, "2"}
    end

    test "returns zero when `buffer` is empty" do
      assert CountL.m("", "", %{}) == {:ok, "0"}
    end

    test "works with ok tuples" do
      assert CountL.m({:ok, "one\ntwo"}, "", %{}) == {:ok, "2"}
    end

    test "allows error tuples to pass through" do
      assert CountL.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
