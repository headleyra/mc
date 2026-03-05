defmodule Mc.Modifier.SortTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Sort

  describe "m/3" do
    test "sorts the `buffer` in ascending order" do
      assert Sort.m("a\nc\nb", "", %{}) == {:ok, "a\nb\nc"}
      assert Sort.m("apple\nzoom\n0-rated\nbanana", "", %{}) == {:ok, "0-rated\napple\nbanana\nzoom"}
    end

    test "works with ok tuples" do
      assert Sort.m({:ok, "banana\napple"}, "", %{}) == {:ok, "apple\nbanana"}
    end

    test "allows error tuples to pass through" do
      assert Sort.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
