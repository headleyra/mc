defmodule Mc.Modifier.MultiplyTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Multiply

  describe "modify/3" do
    test "is able to 'multiply' the `buffer`" do
      assert Multiply.modify("3\n17", "", %{}) == {:ok, "51"}
      assert Multiply.modify("0", "", %{}) == {:ok, "0"}
      assert Multiply.modify("2", "", %{}) == {:ok, "2"}
      assert Multiply.modify("light\n\n2\n4\n\n", "", %{}) == {:ok, "8"}
      assert Multiply.modify(" 3 4 5 ", "", %{}) == {:ok, "60"}
      assert Multiply.modify("\n  1.1\t 4 5", "", %{}) == {:ok, "22.0"}
      assert Multiply.modify("\n1.23\n4\n", "", %{}) == {:ok, "4.92"}
    end

    test "errors when no numbers are found" do
      assert Multiply.modify("", "", %{}) == {:error, "Mc.Modifier.Multiply: no numbers found"}
      assert Multiply.modify("foo bar", "", %{}) == {:error, "Mc.Modifier.Multiply: no numbers found"}
    end

    test "works with ok tuples" do
      assert Multiply.modify({:ok, "3\n4"}, "", %{}) == {:ok, "12"}
    end

    test "allows error tuples to pass through" do
      assert Multiply.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
