defmodule Mc.Modifier.IwordTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Iword

  describe "Mc.Modifier.Iword.modify/2" do
    test "converts integers in the `buffer` to words" do
      assert Iword.modify("127", "n/a") == {:ok, "one hundred and twenty seven"}
      assert Iword.modify("7 till 11", "") == {:ok, "seven\neleven"}
      assert Iword.modify("\n   1 for the money\n  \t 2 for the show\n\n", "") == {:ok, "one\ntwo"}
      assert Iword.modify("1000012 45", "") == {:ok, "one million and twelve\nforty five"}
      assert Iword.modify("028 17", "") == {:ok, "twenty eight\nseventeen"}
    end

    test "returns empty string when no integers are found" do
      assert Iword.modify("", "n/a") == {:ok, ""}
      assert Iword.modify("no integers in here", "") == {:ok, ""}
      assert Iword.modify("3.142 is a float", "") == {:ok, ""}
    end

    test "works with ok tuples" do
      assert Iword.modify({:ok, "BEST\nOF 3"}, "n/a") == {:ok, "three"}
    end

    test "allows error tuples to pass-through" do
      assert Iword.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
