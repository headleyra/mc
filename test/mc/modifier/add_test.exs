defmodule Mc.Modifier.AddTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Add

  describe "modify/3" do
    test "sums the `buffer`" do
      assert Add.modify("1\n7", "", %{}) == {:ok, "8"}
      assert Add.modify("1", "", %{}) == {:ok, "1"}
      assert Add.modify("foo bar\n\n1\n4\n\n", "", %{}) == {:ok, "5"}
      assert Add.modify(" 3 4", "", %{}) == {:ok, "7"}
      assert Add.modify("\n   3.4\t 4  11", "", %{}) == {:ok, "18.4"}
      assert Add.modify("\n1.23\n4\n", "", %{}) == {:ok, "5.23"}
      assert Add.modify("8", "", %{}) == {:ok, "8"}
    end

    test "returns empty string when numbers aren't found" do
      assert Add.modify("", "", %{}) == {:ok, ""}
      assert Add.modify("foo bar", "", %{}) == {:ok, ""}
    end

    test "works with ok tuples" do
      assert Add.modify({:ok, "3\n4"}, "", %{}) == {:ok, "7"}
    end

    test "allows error tuples to pass through" do
      assert Add.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
