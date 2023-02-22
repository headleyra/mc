defmodule Mc.Modifier.DivideTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Divide

  describe "modify/2" do
    test "divides the `buffer`" do
      assert Divide.modify("21\n3", "") == {:ok, "7.0"}
      assert Divide.modify("0   7", "") == {:ok, "0.0"}
      assert Divide.modify("1", "") == {:ok, "1"}
      assert Divide.modify("radio\n\n2\n4\n\n", "") == {:ok, "0.5"}
      assert Divide.modify(" 3 4", "") == {:ok, "0.75"}
      assert Divide.modify("\n   -30.0\t 3  4.0", "") == {:ok, "-2.5"}
    end

    test "errors on divide-by-zero" do
      assert Divide.modify("5\n0", "") == {:error, "Mc.Modifier.Divide#modify: divide-by-zero attempt"}
      assert Divide.modify("1\n0.0", "") == {:error, "Mc.Modifier.Divide#modify: divide-by-zero attempt"}
    end

    test "errors when no numbers are found" do
      assert Divide.modify("", "") == {:error, "Mc.Modifier.Divide#modify: no numbers found"}
      assert Divide.modify("foo bar", "") == {:error, "Mc.Modifier.Divide#modify: no numbers found"}
    end

    test "works with ok tuples" do
      assert Divide.modify({:ok, "3\n4"}, "") == {:ok, "0.75"}
    end

    test "allows error tuples to pass through" do
      assert Divide.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
