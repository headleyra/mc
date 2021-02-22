defmodule Mc.Modifier.RangeTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Range

  describe "Mc.Modifier.Range.modify/2" do
    test "generates a range" do
      assert Range.modify("n/a", "1 3") == {:ok, "1\n2\n3"}
      assert Range.modify("", "2 1") == {:ok, "2\n1"}
      assert Range.modify("", "-1 2") == {:ok, "-1\n0\n1\n2"}
      assert Range.modify("", "-1 -2") == {:ok, "-1\n-2"}
      assert Range.modify("", "1 1") == {:ok, "1"}
      assert Range.modify("", "0 0") == {:ok, "0"}
    end

    test "assumes 1 for a missing limit" do
      assert Range.modify("", "3") == {:ok, "1\n2\n3"}
      assert Range.modify("", "-1") == {:ok, "1\n0\n-1"}
    end

    test "errors when there are zero or more than two range limits" do
      assert Range.modify("", "") == {:error, "usage: range <integer> [<integer>]"}
      assert Range.modify("", "1 2 3") == {:error, "usage: range <integer> [<integer>]"}
    end

    test "errors when `args` aren't integers" do
      assert Range.modify("", "zero 7") == {:error, "usage: range <integer> [<integer>]"}
      assert Range.modify("", "x y") == {:error, "usage: range <integer> [<integer>]"}
      assert Range.modify("", "0 foo") == {:error, "usage: range <integer> [<integer>]"}
    end

    test "works with ok tuples" do
      assert Range.modify({:ok, "n/a"}, "1 2") == {:ok, "1\n2"}
    end

    test "allows error tuples to pass-through" do
      assert Range.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Range.range_for/2" do
    test "generates a range string" do
      assert Range.range_for(1, 3) == "1\n2\n3"
      assert Range.range_for(2, 1) == "2\n1"
      assert Range.range_for(-1, 2) == "-1\n0\n1\n2"
      assert Range.range_for(-1, -3) == "-1\n-2\n-3"
      assert Range.range_for(1, 1) == "1"
    end
  end
end
