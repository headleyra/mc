defmodule Mc.Modifier.PrependTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Prepend

  describe "modify/3" do
    test "parses `args` as a URI-encoded string and prepends it to `buffer`" do
      assert Prepend.modify("23", "1", %{}) == {:ok, "123"}
      assert Prepend.modify("foo\n", "bar%20", %{}) == {:ok, "bar foo\n"}
      assert Prepend.modify("biz", "niz%0a", %{}) == {:ok, "niz\nbiz"}
      assert Prepend.modify("itha", "tab%09", %{}) == {:ok, "tab\titha"}
    end

    test "works with ok tuples" do
      assert Prepend.modify({:ok, "three"}, "best of ", %{}) == {:ok, "best of three"}
    end

    test "allows error tuples to pass through" do
      assert Prepend.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
