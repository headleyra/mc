defmodule Mc.Modifier.SqueezeTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Squeeze

  describe "m/3" do
    test "sqeezes and trims 'non newline' whitespace" do
      assert Squeeze.m("one   four   three", "n/a", %{}) == {:ok, "one four three"}
      assert Squeeze.m(" cash \n  money  ", "", %{}) == {:ok, "cash\nmoney"}
      assert Squeeze.m("tabs\t\tare squeezed   too", "", %{}) == {:ok, "tabs are squeezed too"}
      assert Squeeze.m("          ", "", %{}) == {:ok, ""}
      assert Squeeze.m("   \t     ", "", %{}) == {:ok, ""}
      assert Squeeze.m("   \n     ", "", %{}) == {:ok, "\n"}
      assert Squeeze.m("   \n  \n ", "", %{}) == {:ok, "\n\n"}
    end

    test "works with ok tuples" do
      assert Squeeze.m({:ok, " 1   2\n \t 3 \t"}, "n/a", %{}) == {:ok, "1 2\n3"}
    end

    test "allows error tuples to pass through" do
      assert Squeeze.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
