defmodule Mc.Modifier.MapTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Map

  describe "Mc.Modifier.Map.modify/2" do
    test "parses `args` as an inline string and 'runs' it against each line in the buffer" do
      assert Map.modify("Apple JUICE", "lcase; d le; d ju") == {:ok, "app ice"}
      assert Map.modify("\nbing\n\nbingle\n", "r bing bong") == {:ok, "\nbong\n\nbongle\n"}
      assert Map.modify("\t\nbing\n", "replace bing bong") == {:ok, "\t\nbong\n"}
      assert Map.modify("FOO BAR\nfour four tWo", "lcase; r two 2") == {:ok, "foo bar\nfour four 2"}
      assert Map.modify("FOO BAR\nFOUR FOUR TWO", "lcase%0ar two 2") == {:ok, "foo bar\nfour four 2"}
    end

    test "returns the first error encountered" do
      assert Map.modify("FOO\nBAR", "lcase; error oops") == {:error, "oops"}
      assert Map.modify("FOO\nBAR", "error first; error second") == {:error, "first"}
    end

    test "errors given badly formed URI" do
      assert Map.modify("1\n2", "buffer foo %%0a") == {:error, "usage: Mc.Modifier.Map#modify <inline string>"}
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
end
