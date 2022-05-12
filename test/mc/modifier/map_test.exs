defmodule Mc.Modifier.MapTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Map

  describe "Mc.Modifier.Map.modify/2" do
    test "runs `args` as a script against each line in the `buffer`" do
      assert Map.modify("ApplE JuicE", "lcase") == {:ok, "apple juice"}
      assert Map.modify("1\n2", "map buffer `getb`: `getb; iword`") == {:ok, "1: one\n2: two"}
      assert Map.modify("\nbing\n\nbingle\n", "r bing bong") == {:ok, "\nbong\n\nbongle\n"}
      assert Map.modify("FOO BAR\nfour four tWo", "b `lcase; r two 2`") == {:ok, "foo bar\nfour four 2"}
      assert Map.modify("1\n2", "buffer foo %%09") == {:ok, "foo %\t\nfoo %\t"}
      assert Map.modify("\n\n", "buffer this") == {:ok, "this\nthis\nthis"}
    end

    test "returns errors" do
      assert Map.modify("FOO\nBAR", "error oops") == {:ok, "ERROR: oops\nERROR: oops"}
    end

    test "returns the `buffer` unchanged when `script` is whitespace or empty" do
      assert Map.modify("bing", "") == {:ok, "bing"}
      assert Map.modify("same", "  ") == {:ok, "same"}
      assert Map.modify("", "\n\n   \t") == {:ok, ""}
    end

    test "works with ok tuples" do
      assert Map.modify({:ok, "bing"}, "ucase") == {:ok, "BING"}
    end

    test "allows error tuples to pass-through" do
      assert Map.modify({:error, "reason"}, "lcase") == {:error, "reason"}
    end
  end

  # describe "Mc.Modifier.Map.parse/1" do
  #   test "parses `args` into 'max conconcurrency' and 'script'" do
  #     assert Map.parse("1 bar") == {1, "bar"}
  #     assert Map.parse("2 an inline script") == {2, "an inline script"}
  #     assert Map.parse("8 one two") == {8, "one two"}
  #   end

  #   test "errors when 'max conconcurrency' > 8" do
  #     assert Map.parse("9 bigger than 8") == :error
  #     assert Map.parse("17 seventeen") == :error
  #   end

  #   test "errors when 'max conconcurrency' isn't a positive integer" do
  #     assert Map.parse("0 an inline script") == :error
  #     assert Map.parse("3.142 pie for dinner") == :error
  #     assert Map.parse("-1 auto go") == :error
  #     assert Map.parse("oops auto go") == :error
  #   end
  # end
end
