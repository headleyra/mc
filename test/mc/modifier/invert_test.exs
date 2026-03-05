defmodule Mc.Modifier.InvertTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Invert

  describe "m/3" do
    test "inverts the `buffer`" do
      assert Invert.m("ant\nbar\nzoo\n", "", %{}) == {:ok, "\nzoo\nbar\nant"}
      assert Invert.m("one\ntwo\nthree", "", %{}) == {:ok, "three\ntwo\none"}
      assert Invert.m("\n\n1st line\n2nd line", "n/a", %{}) == {:ok, "2nd line\n1st line\n\n"}
    end

    test "works with ok tuples" do
      assert Invert.m({:ok, "1\n2"}, "n/a", %{}) == {:ok, "2\n1"}
    end

    test "allows error tuples to pass through" do
      assert Invert.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
