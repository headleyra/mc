defmodule Mc.Modifier.GetBTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.GetB

  describe "m/3" do
    test "returns the `buffer`" do
      assert GetB.m("just the\nbuffer", "", %{}) == {:ok, "just the\nbuffer"}
      assert GetB.m("", "", %{}) == {:ok, ""}
    end

    test "works with ok tuples" do
      assert GetB.m({:ok, "best of 3"}, "", %{}) == {:ok, "best of 3"}
    end

    test "allows error tuples to pass through" do
      assert GetB.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
