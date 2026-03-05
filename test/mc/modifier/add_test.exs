defmodule Mc.Modifier.AddTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Add

  describe "m/3" do
    test "sums the `buffer`" do
      assert Add.m("1\n7", "", %{}) == {:ok, "8"}
      assert Add.m("1", "", %{}) == {:ok, "1"}
      assert Add.m("foo bar\n\n1\n4\n\n", "", %{}) == {:ok, "5"}
      assert Add.m(" 3 4", "", %{}) == {:ok, "7"}
      assert Add.m("\n   3.4\t 4  11", "", %{}) == {:ok, "18.4"}
      assert Add.m("\n1.23\n4\n", "", %{}) == {:ok, "5.23"}
      assert Add.m("8", "", %{}) == {:ok, "8"}
    end

    test "returns empty string when numbers aren't found" do
      assert Add.m("", "", %{}) == {:ok, ""}
      assert Add.m("foo bar", "", %{}) == {:ok, ""}
    end

    test "works with ok tuples" do
      assert Add.m({:ok, "3\n4"}, "", %{}) == {:ok, "7"}
    end

    test "allows error tuples to pass through" do
      assert Add.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
