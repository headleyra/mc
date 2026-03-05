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

  describe "m/3" do
    test "filters lines in `buffer` that match the regex given as `args`", %{text: text} do
      assert Grep.m(text, "[Oo]ne", %{}) == {:ok, "One\none"}
      assert Grep.m(text, "two", %{}) == {:ok, "two"}
    end

    test "errors with bad regex" do
      assert Grep.m("one\ntwo", "?", %{}) == {:error, "Mc.Modifier.Grep: bad regex"}
    end

    test "works with ok tuples" do
      assert Grep.m({:ok, "\nfoo\nbar\n"}, "foo", %{}) == {:ok, "foo"}
    end

    test "allows error tuples to pass through" do
      assert Grep.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
