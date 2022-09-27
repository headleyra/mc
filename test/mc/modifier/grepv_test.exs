defmodule Mc.Modifier.GrepvTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Grepv

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

  describe "Mc.Modifier.Grepv.modify/2" do
    test "filters lines in `buffer` that don't match the regex given as `args`", %{text: text} do
      assert Grepv.modify(text, "[Oo]ne") == {:ok, "two\n\nTwo\n"}
      assert Grepv.modify(text, "two") == {:ok, "One\none\n\nTwo\n"}
    end
    
    test "errors with bad regex" do
      assert Grepv.modify("two", "*") == {:error, "Mc.Modifier.Grepv#modify: bad regex"}
    end

    test "works with ok tuples" do
      assert Grepv.modify({:ok, "\nfoo\nbar\n"}, "bar") == {:ok, "\nfoo\n"}
    end

    test "allows error tuples to pass through" do
      assert Grepv.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
