defmodule Mc.Modifier.MapcTest do
  use ExUnit.Case, async: false

  alias Mc.Client.Kv.Memory
  alias Mc.Modifier.Get
  alias Mc.Modifier.Mapc

  setup do
    start_supervised({Memory, map: %{}})
    start_supervised({Get, kv_client: Memory})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Mapc.modify/2" do
    test "parses `args` as a 'concurrency' and 'inline string' and runs it against each line in `buffer`" do
      assert Mapc.modify("ApplE JuicE", "1 lcase") == {:ok, "apple juice"}
      assert Mapc.modify("1\n2", "2 map buffer `getb`: `getb; iword`") == {:ok, "1: one\n2: two"}
      assert Mapc.modify("\nbing\n\nbingle\n", "4 replace bing bong") == {:ok, "\nbong\n\nbongle\n"}
      assert Mapc.modify("FOO BAR\nfour four tWo", "8 b `lcase; r two 2`") == {:ok, "foo bar\nfour four 2"}
      assert Mapc.modify("1\n2", "16 buffer foo %%09") == {:ok, "foo %\t\nfoo %\t"}
      assert Mapc.modify("\n\n", "32 buffer this") == {:ok, "this\nthis\nthis"}
    end

    test "returns the `buffer` when the script is whitespace or empty" do
      assert Mapc.modify("bing", "1") == {:ok, "bing"}
      assert Mapc.modify("same", "2      ") == {:ok, "same"}
      assert Mapc.modify("", "4\t \n") == {:ok, ""}
    end
    
    @errmsg "Mc.Modifier.Mapc#modify: 'max concurrency' should be a positive integer"

    test "errors when `args` doesn't contain a valid 'concurrency' (a.k.a. max. 'cores to use' hint (integer > 0))" do
      assert Mapc.modify("", "") == {:error, @errmsg}
      assert Mapc.modify("", "not-an-integer") == {:error, @errmsg}
      assert Mapc.modify("", "1.2") == {:error, @errmsg}
      assert Mapc.modify("", "-2") == {:error, @errmsg}
      assert Mapc.modify("", "0") == {:error, @errmsg}
    end

    test "accepts 'concurrency' after whitespace" do
      assert Mapc.modify("foo\nbar", "\t2 ucase") == {:ok, "FOO\nBAR"}
      assert Mapc.modify("FOO\nBAR", "  4 lcase") == {:ok, "foo\nbar"}
    end

    test "reports errors" do
      assert Mapc.modify("FOO\nBAR", "2 error oops") == {:ok, "ERROR: oops\nERROR: oops"}
      assert Mapc.modify("1\n2", "4 nah") == {:ok, "ERROR: modifier not found: nah\nERROR: modifier not found: nah"}
    end

    test "works with ok tuples" do
      assert Mapc.modify({:ok, "ONE\nTWO"}, "2 lcase") == {:ok, "one\ntwo"}
    end

    test "allows error tuples to pass through" do
      assert Mapc.modify({:error, "reason"}, "8 lcase") == {:error, "reason"}
    end
  end
end
