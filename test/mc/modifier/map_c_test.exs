defmodule Mc.Modifier.MapCTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.MapC

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{}})
    :ok
  end

  describe "modify/3" do
    test "parses `args` as a 'concurrency' and script and runs it against each line in `buffer`" do
      assert MapC.modify("ApplE  JuicE", "1 casel", %Mc.Mappings{}) == {:ok, "apple  juice"}
      assert MapC.modify("ApplE\nJuicE", "2 casel", %Mc.Mappings{}) == {:ok, "apple\njuice"}
      assert MapC.modify("1\n2", "3 b `getb`: `getb; iword`", %Mc.Mappings{}) == {:ok, "1: one\n2: two"}
      assert MapC.modify("1\n2", "5 b `iword; append %20x`", %Mc.Mappings{}) == {:ok, "one x\ntwo x"}
    end

    @errmsg "Mc.Modifier.MapC: 'concurrency' should be a positive integer"

    test "errors when `args` can't be parsed as a positive integer (max. 'cores to use' hint)" do
      assert MapC.modify("", "", %Mc.Mappings{}) == {:error, @errmsg}
      assert MapC.modify("", "not-an-integer", %Mc.Mappings{}) == {:error, @errmsg}
      assert MapC.modify("", "1.2", %Mc.Mappings{}) == {:error, @errmsg}
      assert MapC.modify("", "-2", %Mc.Mappings{}) == {:error, @errmsg}
      assert MapC.modify("", "0", %Mc.Mappings{}) == {:error, @errmsg}
    end

    test "accepts 'concurrency' after whitespace" do
      assert MapC.modify("foo\nbar", "\t2 caseu", %Mc.Mappings{}) == {:ok, "FOO\nBAR"}
      assert MapC.modify("FOO\nBAR", "  4 casel", %Mc.Mappings{}) == {:ok, "foo\nbar"}
    end

    test "reports errors" do
      assert MapC.modify("FOO\nBAR", "2 error oops", %Mc.Mappings{}) == {:ok, "ERROR: oops\nERROR: oops"}

      assert MapC.modify("1\n2", "4 nah", %Mc.Mappings{}) ==
        {:ok, "ERROR: modifier not found: nah\nERROR: modifier not found: nah"}
    end

    test "works with ok tuples" do
      assert MapC.modify({:ok, "ONE\nTWO"}, "2 casel", %Mc.Mappings{}) == {:ok, "one\ntwo"}
    end

    test "allows error tuples to pass through" do
      assert MapC.modify({:error, "reason"}, "8 casel", %Mc.Mappings{}) == {:error, "reason"}
    end
  end
end
