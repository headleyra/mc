defmodule Mc.Modifier.MulTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Mul

  describe "modify/3" do
    test "is able to 'multiply' the `buffer`" do
      assert Mul.modify("3\n17", "", %{}) == {:ok, "51"}
      assert Mul.modify("0", "", %{}) == {:ok, "0"}
      assert Mul.modify("2", "", %{}) == {:ok, "2"}
      assert Mul.modify("light\n\n2\n4\n\n", "", %{}) == {:ok, "8"}
      assert Mul.modify(" 3 4 5 ", "", %{}) == {:ok, "60"}
      assert Mul.modify("\n  1.1\t 4 5", "", %{}) == {:ok, "22.0"}
      assert Mul.modify("\n1.23\n4\n", "", %{}) == {:ok, "4.92"}
    end

    test "returns empty string when numbers aren't found" do
      assert Mul.modify("", "", %{}) == {:ok, ""}
      assert Mul.modify("foo bar", "", %{}) == {:ok, ""}
    end

    test "works with ok tuples" do
      assert Mul.modify({:ok, "3\n4"}, "", %{}) == {:ok, "12"}
    end

    test "allows error tuples to pass through" do
      assert Mul.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
