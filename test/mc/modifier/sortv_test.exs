defmodule Mc.Modifier.SortvTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Sortv

  describe "modify/2" do
    test "sorts the `buffer` in descending order" do
      assert Sortv.modify("a\nc\nb", "") == {:ok, "c\nb\na"}
      assert Sortv.modify("10\nten\ndix", "") == {:ok, "ten\ndix\n10"}
    end

    test "works with ok tuples" do
      assert Sortv.modify({:ok, "banana\napple"}, "") == {:ok, "banana\napple"}
    end

    test "allows error tuples to pass through" do
      assert Sortv.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
