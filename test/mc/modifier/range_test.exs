defmodule Mc.Modifier.RangeTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Range

  describe "m/3" do
    test "parses `args` as a 'range' and then generates it" do
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

    test "errors when there isn't exactly two limits" do
      assert Range.m("", "", %{}) == {:error, Mc.Modifier.Range, :bad_limits, "", []}
      assert Range.m("", " ", %{}) == {:error, Mc.Modifier.Range, :bad_limits, " ", []}
      assert Range.m("", "1 2 3", %{}) == {:error, Mc.Modifier.Range, :bad_limits, "1 2 3", []}
    end

    test "errors when the range contains non-integers" do
      assert Range.m("", "zero 7", %{}) == {:error, Mc.Modifier.Range, :bad_limits, "zero 7", []}
      assert Range.m("", "x y", %{}) == {:error, Mc.Modifier.Range, :bad_limits, "x y", []}
      assert Range.m("", "0 5.0", %{}) == {:error, Mc.Modifier.Range, :bad_limits, "0 5.0", []}
      assert Range.m("", "#", %{}) == {:error, Mc.Modifier.Range, :bad_limits, "#", []}
    end

    test "works with ok-tuples" do
      assert Range.m({:ok, ""}, "1 2", %{}) == {:ok, "1\n2"}
    end

    test "allows error-tuples to pass through" do
      assert Range.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
