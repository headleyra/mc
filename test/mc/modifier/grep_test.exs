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
    test "filters lines in `buffer` that match the regex given in `args`", %{text: text} do
      assert Grep.modify(text, "[Oo]ne") == {:ok, "One\none"}
    end

    test "returns lines that don't match ('inverse' switch)", %{text: text} do
      assert Grep.modify(text, "--inverse [Oo]ne") == {:ok, "two\n\nTwo\n"}
      assert Grep.modify(text, "-v [Oo]ne") == {:ok, "two\n\nTwo\n"}
    end

    test "errors with bad regex" do
      assert Grep.modify("one\ntwo", "?") == {:error, "Mc.Modifier.Grep#modify: bad regex"}
      assert Grep.modify("two", "-v *") == {:error, "Mc.Modifier.Grep#modify: bad regex"}
    end

    test "returns a help message" do
      assert Check.has_help?(Grep, :modify)
    end

    test "errors with unknown switches" do
      assert Grep.modify("", "--unknown") == {:error, "Mc.Modifier.Grep#modify: switch parse error"}
      assert Grep.modify("", "-u") == {:error, "Mc.Modifier.Grep#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Grep.modify({:ok, "\nfoo\nbar\n"}, "foo") == {:ok, "foo"}
      assert Grep.modify({:ok, "\nfoo\nbar\n"}, "-v bar") == {:ok, "\nfoo\n"}
    end

    test "allows error tuples to pass through" do
      assert Grep.modify({:error, "reason"}, "") == {:error, "reason"}
      assert Grep.modify({:error, "reason"}, "-v") == {:error, "reason"}
    end
  end
end
