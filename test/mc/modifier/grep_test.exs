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

    test "returns an error tuple when the regex is bad" do
      assert Grep.modify("one\ntwo", "?") == {:error, "Grep: bad regex"}
    end

    test "works with ok tuples" do
      assert Grep.modify({:ok, "\nfoo\nbar\n"}, "foo") == {:ok, "foo"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Grep.modify({:error, "reason"}, "gets ignored") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Grep.modifyv/2" do
    test "returns lines that don't match", %{text: text} do
      assert Grep.modifyv(text, "[Oo]ne") == {:ok, "two\n\nTwo\n"}
    end

    test "returns an error tuple when the regex is bad" do
      assert Grep.modifyv("one\ntwo", "*") == {:error, "Grep: bad regex"}
    end

    test "works with ok tuples" do
      assert Grep.modifyv({:ok, "\nfoo\nbar\n"}, "bar") == {:ok, "\nfoo\n"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Grep.modifyv({:error, "reason"}, "gets ignored") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Grep.grep/3" do
    test "returns each line in `buffer` that matches the regex in `args`", %{text: text} do
      assert Grep.grep(text, "[Oo]ne", :n) == {:ok, "One\none"}
      assert Grep.grep(text, "wo", :n) == {:ok, "two\nTwo"}
    end

    test "returns empty string when `buffer` is an empty string" do
      assert Grep.grep("", "", :n) == {:ok, ""}
    end

    test "returns empty string when the regex doesn't match", %{text: text} do
      assert Grep.grep(text, "nah", :n) == {:ok, ""}
    end

    test "returns lines that don't match", %{text: text} do
      assert Grep.grep(text, "one", :v) == {:ok, "One\ntwo\n\nTwo\n"}
    end

    test "returns empty string when `buffer` is an empty string (inverse)" do
      assert Grep.grep("", "n/a", :v) == {:ok, ""}
    end

    test "returns an error tuple when the regex is bad" do
      assert Grep.grep("", "?", :n) == {:error, "Grep: bad regex"}
      assert Grep.grep("", "*", :v) == {:error, "Grep: bad regex"}
    end
  end
end
