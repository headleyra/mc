defmodule Mc.Modifier.DivTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Div

  describe "modify/3" do
    test "divides the `buffer`" do
      assert Div.modify("21\n3", "", %{}) == {:ok, "7.0"}
      assert Div.modify("0   7", "", %{}) == {:ok, "0.0"}
      assert Div.modify("1", "", %{}) == {:ok, "1"}
      assert Div.modify("radio\n\n2\n4\n\n", "", %{}) == {:ok, "0.5"}
      assert Div.modify(" 3 4", "", %{}) == {:ok, "0.75"}
      assert Div.modify("\n   -30.0\t 3  4.0", "", %{}) == {:ok, "-2.5"}
    end

    test "errors on divide-by-zero" do
      assert Div.modify("5\n0", "", %{}) == {:error, "Mc.Modifier.Div: divide-by-zero attempt"}
      assert Div.modify("1\n0.0", "", %{}) == {:error, "Mc.Modifier.Div: divide-by-zero attempt"}
    end

    test "returns empty string when numbers aren't found" do
      assert Div.modify("", "", %{}) == {:ok, ""}
      assert Div.modify("foo bar", "", %{}) == {:ok, ""}
    end

    test "works with ok tuples" do
      assert Div.modify({:ok, "3\n4"}, "", %{}) == {:ok, "0.75"}
    end

    test "allows error tuples to pass through" do
      assert Div.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
