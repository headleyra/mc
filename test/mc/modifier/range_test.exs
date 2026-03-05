defmodule Mc.Modifier.RangeTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Range

  describe "m/3" do
    test "generates a range" do
      assert Range.m("n/a", "1 3", %{}) == {:ok, "1\n2\n3"}
      assert Range.m("", "2 1", %{}) == {:ok, "2\n1"}
      assert Range.m("", "-1 2", %{}) == {:ok, "-1\n0\n1\n2"}
      assert Range.m("", "-1 -2", %{}) == {:ok, "-1\n-2"}
      assert Range.m("", "1 1", %{}) == {:ok, "1"}
      assert Range.m("", "0 0", %{}) == {:ok, "0"}
    end

    test "assumes 1 for a missing start limit" do
      assert Range.m("", "3", %{}) == {:ok, "1\n2\n3"}
      assert Range.m("", "-1", %{}) == {:ok, "1\n0\n-1"}
    end

    test "errors when there are zero or more than two range limits" do
      assert Range.m("", "", %{}) == {:error, "Mc.Modifier.Range: bad range"}
      assert Range.m("", "  ", %{}) == {:error, "Mc.Modifier.Range: bad range"}
      assert Range.m("", "1 2 3", %{}) == {:error, "Mc.Modifier.Range: bad range"}
    end

    test "errors when `args` aren't integers" do
      assert Range.m("", "zero 7", %{}) == {:error, "Mc.Modifier.Range: bad range"}
      assert Range.m("", "x y", %{}) == {:error, "Mc.Modifier.Range: bad range"}
      assert Range.m("", "0 foo", %{}) == {:error, "Mc.Modifier.Range: bad range"}
    end

    test "works with ok tuples" do
      assert Range.m({:ok, ""}, "1 2", %{}) == {:ok, "1\n2"}
    end

    test "allows error tuples to pass through" do
      assert Range.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
