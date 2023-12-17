defmodule Mc.Modifier.GetBTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.GetB

  describe "modify/3" do
    test "returns the `buffer`" do
      assert GetB.modify("just the\nbuffer", "", %{}) == {:ok, "just the\nbuffer"}
      assert GetB.modify("", "", %{}) == {:ok, ""}
    end

    test "works with ok tuples" do
      assert GetB.modify({:ok, "best of 3"}, "", %{}) == {:ok, "best of 3"}
    end

    test "allows error tuples to pass through" do
      assert GetB.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
