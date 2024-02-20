defmodule Mc.Modifier.SubTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Sub

  describe "modify/3" do
    test "subtracts the `buffer`" do
      assert Sub.modify("17\n3", "", %{}) == {:ok, "14"}
      assert Sub.modify("3", "", %{}) == {:ok, "3"}
      assert Sub.modify("bosh\n\n2\n4\n\n", "", %{}) == {:ok, "-2"}
      assert Sub.modify(" 3 4", "", %{}) == {:ok, "-1"}
      assert Sub.modify("\n   1.1\t 4  5", "", %{}) == {:ok, "-7.9"}
      assert Sub.modify("4\n1.23", "", %{}) == {:ok, "2.77"}
    end

    test "returns empty string when numbers aren't found" do
      assert Sub.modify("", "", %{}) == {:ok, ""}
      assert Sub.modify("foo bar", "", %{}) == {:ok, ""}
    end

    test "works with ok tuples" do
      assert Sub.modify({:ok, "3\n4"}, "", %{}) == {:ok, "-1"}
    end

    test "allows error tuples to pass through" do
      assert Sub.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
