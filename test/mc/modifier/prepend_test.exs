defmodule Mc.Modifier.PrependTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Prepend

  describe "modify/3" do
    test "parses `args` as an 'inline string' and prepends it to `buffer`" do
      assert Prepend.modify("23", "1", %{}) == {:ok, "123"}
      assert Prepend.modify("\nbar", "foo", %{}) == {:ok, "foo\nbar"}
      assert Prepend.modify("same same", "", %{}) == {:ok, "same same"}
    end

    test "works with ok tuples" do
      assert Prepend.modify({:ok, "three"}, "best of ", %{}) == {:ok, "best of three"}
    end

    test "allows error tuples to pass through" do
      assert Prepend.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
