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

  describe "Mc.Modifier.Grep.modify/2" do
    test "searches each line in `buffer` and returns those that match the regex given in `args`", %{text: text} do
      assert Grep.modify(text, "[Oo]ne") == {:ok, "One\none"}
    end

    test "errors when the regex is bad" do
      assert Grep.modify("one\ntwo", "?") == {:error, "usage: Mc.Modifier.Grep#modify <regex>"}
    end

    test "works with ok tuples" do
      assert Grep.modify({:ok, "\nfoo\nbar\n"}, "foo") == {:ok, "foo"}
    end

    test "allows error tuples to pass-through" do
      assert Grep.modify({:error, "reason"}, "gets ignored") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Grep.modifyv/2" do
    test "returns lines that don't match", %{text: text} do
      assert Grep.modifyv(text, "[Oo]ne") == {:ok, "two\n\nTwo\n"}
    end

    test "errors when the regex is bad" do
      assert Grep.modifyv("one\ntwo", "*") == {:error, "usage: Mc.Modifier.Grep#modifyv <regex>"}
    end

    test "works with ok tuples" do
      assert Grep.modifyv({:ok, "\nfoo\nbar\n"}, "bar") == {:ok, "\nfoo\n"}
    end

    test "allows error tuples to pass-through" do
      assert Grep.modifyv({:error, "reason"}, "gets ignored") == {:error, "reason"}
    end
  end
end
