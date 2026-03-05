defmodule Mc.Modifier.SubTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Sub

  describe "m/3" do
    test "subtracts the `buffer`" do
      assert Sub.m("17\n3", "", %{}) == {:ok, "14"}
      assert Sub.m("3", "", %{}) == {:ok, "3"}
      assert Sub.m("bosh\n\n2\n4\n\n", "", %{}) == {:ok, "-2"}
      assert Sub.m(" 3 4", "", %{}) == {:ok, "-1"}
      assert Sub.m("\n   1.1\t 4  5", "", %{}) == {:ok, "-7.9"}
      assert Sub.m("4\n1.23", "", %{}) == {:ok, "2.77"}
    end

    test "returns empty string when numbers aren't found" do
      assert Sub.m("", "", %{}) == {:ok, ""}
      assert Sub.m("foo bar", "", %{}) == {:ok, ""}
    end

    test "works with ok tuples" do
      assert Sub.m({:ok, "3\n4"}, "", %{}) == {:ok, "-1"}
    end

    test "allows error tuples to pass through" do
      assert Sub.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
