defmodule Mc.Modifier.MapCTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.MapC

  defmodule Mappings do
    defstruct [
      append: Mc.Modifier.Append,
      b: Mc.Modifier.Buffer,
      error: Mc.Modifier.Error,
      getb: Mc.Modifier.GetB,
      iword: Mc.Modifier.Iword,
      lcase: Mc.Modifier.Lcase,
      ucase: Mc.Modifier.Ucase
    ]
  end

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{}})
    :ok
  end

  describe "modify/3" do
    test "parses `args` as a 'concurrency' and script and runs it against each line in `buffer`" do
      assert MapC.modify("ApplE  JuicE", "1 lcase", %Mappings{}) == {:ok, "apple  juice"}
      assert MapC.modify("ApplE\nJuicE", "2 lcase", %Mappings{}) == {:ok, "apple\njuice"}
      assert MapC.modify("1\n2", "3 b `getb`: `getb; iword`", %Mappings{}) == {:ok, "1: one\n2: two"}
      assert MapC.modify("1\n2", "5 b `iword; append %20x`", %Mappings{}) == {:ok, "one x\ntwo x"}
    end

    @errmsg "Mc.Modifier.MapC: 'concurrency' should be a positive integer"

    test "errors when `args` can't be parsed as a positive integer (max. 'cores to use' hint)" do
      assert MapC.modify("", "", %Mappings{}) == {:error, @errmsg}
      assert MapC.modify("", "not-an-integer", %Mappings{}) == {:error, @errmsg}
      assert MapC.modify("", "1.2", %Mappings{}) == {:error, @errmsg}
      assert MapC.modify("", "-2", %Mappings{}) == {:error, @errmsg}
      assert MapC.modify("", "0", %Mappings{}) == {:error, @errmsg}
    end

    test "accepts 'concurrency' after whitespace" do
      assert MapC.modify("foo\nbar", "\t2 ucase", %Mappings{}) == {:ok, "FOO\nBAR"}
      assert MapC.modify("FOO\nBAR", "  4 lcase", %Mappings{}) == {:ok, "foo\nbar"}
    end

    test "reports errors" do
      assert MapC.modify("FOO\nBAR", "2 error oops", %Mappings{}) == {:ok, "ERROR: oops\nERROR: oops"}

      assert MapC.modify("1\n2", "4 nah", %Mappings{}) ==
        {:ok, "ERROR: modifier not found: nah\nERROR: modifier not found: nah"}
    end

    test "works with ok tuples" do
      assert MapC.modify({:ok, "ONE\nTWO"}, "2 lcase", %Mappings{}) == {:ok, "one\ntwo"}
    end

    test "allows error tuples to pass through" do
      assert MapC.modify({:error, "reason"}, "8 lcase", %Mappings{}) == {:error, "reason"}
    end
  end
end
