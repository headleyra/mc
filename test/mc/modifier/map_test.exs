defmodule Mc.Modifier.MapTest do
  use ExUnit.Case, async: false

  alias Mc.Client.Kv
  alias Mc.Modifier.Get
  alias Mc.Modifier.Map

  setup do
    start_supervised({Kv, map: %{}})
    start_supervised({Get, kv_client: Kv})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Map.modify/2" do
    test "parses `args` as a script and runs it against each line in the `buffer`" do
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

    test "accepts a 'concurrency' switch (maximum number of CPU cores to use)" do
      assert Map.modify("1\n2", "--concurrency 2 iword") == {:ok, "one\ntwo"}
      assert Map.modify("1\n2", "-c 2 iword") == {:ok, "one\ntwo"}
      assert Map.modify("1\n2", "-c 5 append a") == {:ok, "1a\n2a"}
    end

    test "errors when 'concurrency' isn't a positive integer" do
      assert Map.modify("1\n2", "-c foo iword") == {:error, "Mc.Modifier.Map#modify: switch parse error"}
      assert Map.modify("1\n2", "-c 5.7 iword") == {:error, "Mc.Modifier.Map#modify: switch parse error"}
      assert Map.modify("1\n2", "-c -3 iword") == {:error, "Mc.Modifier.Map#modify: switch parse error"}
      assert Map.modify("1\n2", "-c 0 iword") == {:error, "Mc.Modifier.Map#modify: switch parse error"}
    end

    test "reports errors" do
      assert Map.modify("FOO\nBAR", "error oops") == {:ok, "ERROR: oops\nERROR: oops"}
      assert Map.modify("1\n2", "x") == {:ok, "ERROR: modifier not found 'x'\nERROR: modifier not found 'x'"}
    end

    test "returns a help message" do
      assert Check.has_help?(Map, :modify)
    end

    test "errors with unknown switches" do
      assert Map.modify("", "--unknown") == {:error, "Mc.Modifier.Map#modify: switch parse error"}
      assert Map.modify("", "-u") == {:error, "Mc.Modifier.Map#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Map.modify({:ok, "bing"}, "ucase") == {:ok, "BING"}
      assert Map.modify({:ok, "bing"}, "-c 2 ucase") == {:ok, "BING"}
    end

    test "allows error tuples to pass through" do
      assert Map.modify({:error, "reason"}, "lcase") == {:error, "reason"}
      assert Map.modify({:error, "reason"}, "-c 5 lcase") == {:error, "reason"}
    end
  end
end
