defmodule Mc.Modifier.InvertTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Invert

  describe "Mc.Modifier.Invert.modify/2" do
    test "inverts the `buffer`" do
      assert Invert.modify("ant\nbar\nzoo\n", "") == {:ok, "\nzoo\nbar\nant"}
      assert Invert.modify("\n1st line\n2nd line, blah blah", "n/a") == {:ok, "2nd line, blah blah\n1st line\n"}
    end

    test "returns \"\" when `buffer` is \"\"" do
      assert Invert.modify("", "") == {:ok, ""}
      assert Invert.modify("", "foo") == {:ok, ""}
    end

    test "works with ok tuples" do
      assert Invert.modify({:ok, "1\n2"}, "n/a") == {:ok, "2\n1"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Invert.modify({:error, "reason"}, "n/a") == {:error, "reason"}
    end
  end
end
