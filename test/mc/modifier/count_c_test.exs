defmodule Mc.Modifier.CountCTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.CountC

  describe "modify/3" do
    test "returns the number of characters in the `buffer`" do
      assert CountC.modify("123", "", %{}) == {:ok, "3"}
      assert CountC.modify("123\n", "", %{}) == {:ok, "4"}
      assert CountC.modify("\tStrong and stable\n\n", "", %{}) == {:ok, "20"}
    end

    test "works with ok tuples" do
      assert CountC.modify({:ok, "Over 50k"}, "", %{}) == {:ok, "8"}
    end

    test "allows error tuples to pass through" do
      assert CountC.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
