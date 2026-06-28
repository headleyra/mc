defmodule Mc.Modifier.PrependTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Prepend

  describe "m/3" do
    test "parses `args` as a URI-encoded string and prepends it to `buffer`" do
      assert Prepend.m("23", "1", %{}) == {:ok, "123"}
      assert Prepend.m("bar\n", "foo%20", %{}) == {:ok, "foo bar\n"}
      assert Prepend.m("niz", "biz%0a", %{}) == {:ok, "biz\nniz"}
      assert Prepend.m("itha", "tab%09", %{}) == {:ok, "tab\titha"}
    end

    test "works with ok-tuples" do
      assert Prepend.m({:ok, "three"}, "best of ", %{}) == {:ok, "best of three"}
    end

    test "allows error-tuples to pass through" do
      assert Prepend.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
