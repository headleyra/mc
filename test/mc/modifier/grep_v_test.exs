defmodule Mc.Modifier.GrepVTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.GrepV

  setup do
    %{
      text: """
      One
      one
      two

      Two
      """
    }
  end

  describe "m/3" do
    test "filters lines in `buffer` that don't match the regex given as `args`", %{text: text} do
      assert GrepV.m(text, "[Oo]ne", %{}) == {:ok, "two\n\nTwo\n"}
      assert GrepV.m(text, "two", %{}) == {:ok, "One\none\n\nTwo\n"}
    end
    
    test "errors with bad regex" do
      assert GrepV.m("two", "*", %{}) == {:error, "Mc.Modifier.GrepV: bad regex"}
    end

    test "works with ok tuples" do
      assert GrepV.m({:ok, "\nfoo\nbar\n"}, "bar", %{}) == {:ok, "\nfoo\n"}
    end

    test "allows error tuples to pass through" do
      assert GrepV.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
