defmodule Mc.Modifier.SubtractTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Subtract

  describe "Mc.Modifier.Subtract.modify/2" do
    test "subtracts the `buffer`" do
      assert Subtract.modify("17\n3", "") == {:ok, "14"}
      assert Subtract.modify("3", "") == {:ok, "3"}
      assert Subtract.modify("bosh\n\n2\n4\n\n", "") == {:ok, "-2"}
      assert Subtract.modify(" 3 4", "") == {:ok, "-1"}
      assert Subtract.modify("\n   1.1\t 4  5", "") == {:ok, "-7.9"}
      assert Subtract.modify("4\n1.23", "") == {:ok, "2.77"}
    end

    test "errors when no numbers are found" do
      assert Subtract.modify("", "") == {:error, "Mc.Modifier.Subtract#modify: no numbers found"}
      assert Subtract.modify("foo bar", "") == {:error, "Mc.Modifier.Subtract#modify: no numbers found"}
    end

    test "works with ok tuples" do
      assert Subtract.modify({:ok, "3\n4"}, "") == {:ok, "-1"}
    end

    test "allows error tuples to pass through" do
      assert Subtract.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
