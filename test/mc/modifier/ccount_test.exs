defmodule Mc.Modifier.CcountTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Ccount

  describe "Mc.Modifier.Ccount.modify/2" do
    test "returns the number of characters in the `buffer`" do
      assert Ccount.modify("123", "n/a") == {:ok, "3"}
      assert Ccount.modify("123\n", "ignored") == {:ok, "4"}
      assert Ccount.modify("\tStrong and stable\n\n", "ignored") == {:ok, "20"}
    end

    test "works with ok tuples" do
      assert Ccount.modify({:ok, "Over 50k"}, "n/a") == {:ok, "8"}
    end

    test "allows error tuples to pass-through" do
      assert Ccount.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
