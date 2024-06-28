defmodule Mc.Modifier.AppendTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Append

  describe "modify/3" do
    test "parses `args` as an 'inline string' and appends it to `buffer`" do
      assert Append.modify("12", "3", %{}) == {:ok, "123"}
      assert Append.modify("foo\n", "bar", %{}) == {:ok, "foo\nbar"}
    end

    test "works with ok tuples" do
      assert Append.modify({:ok, "best of "}, "three", %{}) == {:ok, "best of three"}
    end

    test "allows error tuples to pass through" do
      assert Append.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
