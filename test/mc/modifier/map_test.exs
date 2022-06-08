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

    test "returns the `buffer` unchanged when `script` is whitespace or empty" do
      assert Map.modify("bing", "") == {:ok, "bing"}
      assert Map.modify("same", "  ") == {:ok, "same"}
      assert Map.modify("", "\n\n   \t") == {:ok, ""}
    end

    test "accepts a 'concurrency' integer (maximum number of CPU cores to use)" do
      assert Map.modify("1\n2", "-c 8 iword") == {:ok, "one\ntwo"}
      assert Map.modify("1\n2", "--concurrency 1 iword") == {:ok, "one\ntwo"}
    end

    test "errors when 'concurrency' isn't a positive integer" do
      assert Map.modify("1\n2", "-c foo iword") ==
        {:error, "usage: Mc.Modifier.Map#modify [-c <integer:positive>] <modifier> [<args>]"}

      assert Map.modify("1\n2", "-k 5 iword") ==
        {:error, "usage: Mc.Modifier.Map#modify [-c <integer:positive>] <modifier> [<args>]"}

      assert Map.modify("1\n2", "-c -3 iword") ==
        {:error, "usage: Mc.Modifier.Map#modify [-c <integer:positive>] <modifier> [<args>]"}

      assert Map.modify("1\n2", "-c 0 iword") ==
        {:error, "usage: Mc.Modifier.Map#modify [-c <integer:positive>] <modifier> [<args>]"}
    end

    test "report errors" do
      assert Map.modify("FOO\nBAR", "error oops") == {:ok, "ERROR: oops\nERROR: oops"}
      assert Map.modify("1\n2", "x") == {:ok, "ERROR: modifier not found 'x'\nERROR: modifier not found 'x'"}
    end

    test "works with ok tuples" do
      assert Map.modify({:ok, "bing"}, "ucase") == {:ok, "BING"}
    end

    test "allows error tuples to pass-through" do
      assert Map.modify({:error, "reason"}, "lcase") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Map.parse/1" do
    test "parses its input for the 'concurrency' option" do
      assert Map.parse("-c 2 rand 10") == {"rand 10", [concurrency: 2]}
      assert Map.parse("--concurrency 3 modi 7") == {"modi 7", [concurrency: 3]}
    end

    test "returns a default 'concurrency' of 1" do
      assert Map.parse("some script") == {"some script", [concurrency: 1]}
    end

    test "errors when 'concurrency' can't be parsed" do
      assert Map.parse("-c not-an-integer arguments") == :error
    end

    test "errors when 'concurrency' is negative or zero" do
      assert Map.parse("-c -1 modi") == :error
      assert Map.parse("-c 0 modi") == :error
    end

    test "doesn't allow unknown options" do
      assert Map.parse("--unknown 7 mod") == :error
      assert Map.parse("-u bosh mod") == :error
    end
  end
end
