defmodule Mc.Modifier.AppendTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Append

  describe "m/3" do
    test "parses `args` as a URI-encoded string and appends it to `buffer`" do
      assert Append.m("12", "3", %{}) == {:ok, "123"}
      assert Append.m(" foo\n", "bar%20", %{}) == {:ok, " foo\nbar "}
      assert Append.m("biz", "%0aniz", %{}) == {:ok, "biz\nniz"}
      assert Append.m("tab", "%09itha", %{}) == {:ok, "tab\titha"}
    end

    test "works with ok tuples" do
      assert Append.m({:ok, "best of "}, "three", %{}) == {:ok, "best of three"}
    end

    test "allows error tuples to pass through" do
      assert Append.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
