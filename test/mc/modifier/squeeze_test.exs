defmodule Mc.Modifier.SqueezeTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Squeeze

  describe "Mc.Modifier.Squeeze.modify/2" do
    test "sqeezes and trims 'non newline' whitespace" do
      assert Squeeze.modify("one   four   three", "n/a") == {:ok, "one four three"}
      assert Squeeze.modify(" cash \n  money  ", "") == {:ok, "cash\nmoney"}
      assert Squeeze.modify("tabs\t\tare squeezed   too", "") == {:ok, "tabs are squeezed too"}
      assert Squeeze.modify("          ", "") == {:ok, ""}
      assert Squeeze.modify("   \t     ", "") == {:ok, ""}
      assert Squeeze.modify("   \n     ", "") == {:ok, "\n"}
      assert Squeeze.modify("   \n  \n ", "") == {:ok, "\n\n"}
    end

    test "works with ok tuples" do
      assert Squeeze.modify({:ok, " 1   2\n \t 3 \t"}, "n/a") == {:ok, "1 2\n3"}
    end

    test "allows error tuples to pass through" do
      assert Squeeze.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
