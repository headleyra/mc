defmodule Mc.Modifier.InvertTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Invert

  describe "modify/2" do
    test "inverts the `buffer`" do
      assert Invert.modify("ant\nbar\nzoo\n", "") == {:ok, "\nzoo\nbar\nant"}
      assert Invert.modify("one\ntwo\nthree", "") == {:ok, "three\ntwo\none"}
      assert Invert.modify("\n\n1st line\n2nd line", "n/a") == {:ok, "2nd line\n1st line\n\n"}
    end

    test "works with ok tuples" do
      assert Invert.modify({:ok, "1\n2"}, "n/a") == {:ok, "2\n1"}
    end

    test "allows error tuples to pass through" do
      assert Invert.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
