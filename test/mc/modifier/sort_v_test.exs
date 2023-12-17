defmodule Mc.Modifier.SortVTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.SortV

  describe "modify/3" do
    test "sorts the `buffer` in descending order" do
      assert SortV.modify("a\nc\nb", "", %{}) == {:ok, "c\nb\na"}
      assert SortV.modify("10\nten\ndix", "", %{}) == {:ok, "ten\ndix\n10"}
    end

    test "works with ok tuples" do
      assert SortV.modify({:ok, "banana\napple"}, "", %{}) == {:ok, "banana\napple"}
    end

    test "allows error tuples to pass through" do
      assert SortV.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
