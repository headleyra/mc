defmodule Mc.Modifier.CcountTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Ccount

  describe "Mc.Modifier.Ccount.modify/2" do
    test "returns the number of characters in the `buffer`" do
      assert Ccount.modify("123", "") == {:ok, "3"}
      assert Ccount.modify("123\n", "") == {:ok, "4"}
      assert Ccount.modify("\tStrong and stable\n\n", "") == {:ok, "20"}
    end

    test "returns a help message" do
      assert Check.has_help?(Ccount, :modify)
    end

    test "errors with unknown switches" do
      assert Ccount.modify("n/a", "--unknown") == {:error, "Mc.Modifier.Ccount#modify: switch parse error"}
      assert Ccount.modify("", "-u") == {:error, "Mc.Modifier.Ccount#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Ccount.modify({:ok, "Over 50k"}, "") == {:ok, "8"}
    end

    test "allows error tuples to pass through" do
      assert Ccount.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
