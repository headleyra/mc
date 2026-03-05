defmodule Mc.Modifier.PrependTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Prepend

  describe "m/3" do
    test "parses `args` as a URI-encoded string and prepends it to `buffer`" do
      assert Prepend.m("23", "1", %{}) == {:ok, "123"}
      assert Prepend.m("foo\n", "bar%20", %{}) == {:ok, "bar foo\n"}
      assert Prepend.m("biz", "niz%0a", %{}) == {:ok, "niz\nbiz"}
      assert Prepend.m("itha", "tab%09", %{}) == {:ok, "tab\titha"}
    end

    test "works with ok tuples" do
      assert Prepend.m({:ok, "three"}, "best of ", %{}) == {:ok, "best of three"}
    end

    test "allows error tuples to pass through" do
      assert Prepend.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
