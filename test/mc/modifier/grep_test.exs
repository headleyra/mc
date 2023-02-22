defmodule Mc.Modifier.GrepTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Grep

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

  describe "modify/2" do
    test "filters lines in `buffer` that match the regex given as `args`", %{text: text} do
      assert Grep.modify(text, "[Oo]ne") == {:ok, "One\none"}
      assert Grep.modify(text, "two") == {:ok, "two"}
    end

    test "errors with bad regex" do
      assert Grep.modify("one\ntwo", "?") == {:error, "Mc.Modifier.Grep#modify: bad regex"}
    end

    test "works with ok tuples" do
      assert Grep.modify({:ok, "\nfoo\nbar\n"}, "foo") == {:ok, "foo"}
    end

    test "allows error tuples to pass through" do
      assert Grep.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
