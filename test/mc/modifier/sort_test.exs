defmodule Mc.Modifier.SortTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Sort

  describe "modify/3" do
    test "sorts the `buffer` in ascending order" do
      assert Sort.modify("a\nc\nb", "", %{}) == {:ok, "a\nb\nc"}
      assert Sort.modify("apple\nzoom\n0-rated\nbanana", "", %{}) == {:ok, "0-rated\napple\nbanana\nzoom"}
    end

    test "works with ok tuples" do
      assert Sort.modify({:ok, "banana\napple"}, "", %{}) == {:ok, "apple\nbanana"}
    end

    test "allows error tuples to pass through" do
      assert Sort.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
