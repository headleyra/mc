defmodule Mc.Modifier.RangeTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Range

  describe "modify/3" do
    test "generates a range" do
      assert Range.modify("n/a", "1 3", %{}) == {:ok, "1\n2\n3"}
      assert Range.modify("", "2 1", %{}) == {:ok, "2\n1"}
      assert Range.modify("", "-1 2", %{}) == {:ok, "-1\n0\n1\n2"}
      assert Range.modify("", "-1 -2", %{}) == {:ok, "-1\n-2"}
      assert Range.modify("", "1 1", %{}) == {:ok, "1"}
      assert Range.modify("", "0 0", %{}) == {:ok, "0"}
    end

    test "assumes 1 for a missing start limit" do
      assert Range.modify("", "3", %{}) == {:ok, "1\n2\n3"}
      assert Range.modify("", "-1", %{}) == {:ok, "1\n0\n-1"}
    end

    test "errors when there are zero or more than two range limits" do
      assert Range.modify("", "", %{}) == {:error, "Mc.Modifier.Range#modify: bad range"}
      assert Range.modify("", "  ", %{}) == {:error, "Mc.Modifier.Range#modify: bad range"}
      assert Range.modify("", "1 2 3", %{}) == {:error, "Mc.Modifier.Range#modify: bad range"}
    end

    test "errors when `args` aren't integers" do
      assert Range.modify("", "zero 7", %{}) == {:error, "Mc.Modifier.Range#modify: bad range"}
      assert Range.modify("", "x y", %{}) == {:error, "Mc.Modifier.Range#modify: bad range"}
      assert Range.modify("", "0 foo", %{}) == {:error, "Mc.Modifier.Range#modify: bad range"}
    end

    test "works with ok tuples" do
      assert Range.modify({:ok, ""}, "1 2", %{}) == {:ok, "1\n2"}
    end

    test "allows error tuples to pass through" do
      assert Range.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
