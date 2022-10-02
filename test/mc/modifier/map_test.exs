defmodule Mc.Modifier.MapTest do
  use ExUnit.Case, async: false

  alias Mc.Client.Kv.Memory
  alias Mc.Modifier.Get
  alias Mc.Modifier.Map

  setup do
    start_supervised({Memory, map: %{}})
    start_supervised({Get, kv_client: Memory})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Map.modify/2" do
    test "parses `args` as an 'inline string' and runs it against each line in the `buffer`" do
      assert Map.modify("ApplE JuicE", "lcase") == {:ok, "apple juice"}
      assert Map.modify("1\n2", "map buffer `getb`: `getb; iword`") == {:ok, "1: one\n2: two"}
      assert Map.modify("\nbing\n\nbingle\n", "r bing bong") == {:ok, "\nbong\n\nbongle\n"}
      assert Map.modify("FOO BAR\nfour four tWo", "b `lcase; r two 2`") == {:ok, "foo bar\nfour four 2"}
      assert Map.modify("1\n2", "buffer foo %%09") == {:ok, "foo %\t\nfoo %\t"}
      assert Map.modify("\n\n", "buffer this") == {:ok, "this\nthis\nthis"}
    end

    test "returns `buffer` when the script is whitespace or empty" do
      assert Map.modify("bing", "") == {:ok, "bing"}
      assert Map.modify("same", "  ") == {:ok, "same"}
      assert Map.modify("", "\n\n   \t") == {:ok, ""}
    end
    
    test "reports errors" do
      assert Map.modify("FOO\nBAR", "error oops") == {:ok, "ERROR: oops\nERROR: oops"}
      assert Map.modify("1\n2", "ex") == {:ok, "ERROR: modifier not found: ex\nERROR: modifier not found: ex"}
    end

    test "works with ok tuples" do
      assert Map.modify({:ok, "bish\nbosh"}, "ucase") == {:ok, "BISH\nBOSH"}
    end

    test "allows error tuples to pass through" do
      assert Map.modify({:error, "reason"}, "lcase") == {:error, "reason"}
    end
  end
end
