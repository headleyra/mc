defmodule Mc.Modifier.MapcTest do
  use ExUnit.Case, async: false

  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.Mapc

  defmodule Mappings do
    defstruct [
      append: {Mc.Modifier.Append, :modify},
      b: {Mc.Modifier.Buffer, :modify},
      error: {Mc.Modifier.Error, :modify},
      getb: {Mc.Modifier.Getb, :modify},
      iword: {Mc.Modifier.Iword, :modify},
      lcase: {Mc.Modifier.Lcase, :modify},
      ucase: {Mc.Modifier.Ucase, :modify}
    ]
  end

  setup do
    start_supervised({KvMemory, map: %{}})
    :ok
  end

  describe "modify/3" do
    test "parses `args` as a 'concurrency' and script and runs it against each line in `buffer`" do
      assert Mapc.modify("ApplE  JuicE", "1 lcase", %Mappings{}) == {:ok, "apple  juice"}
      assert Mapc.modify("ApplE\nJuicE", "2 lcase", %Mappings{}) == {:ok, "apple\njuice"}
      assert Mapc.modify("1\n2", "3 b `getb`: `getb; iword`", %Mappings{}) == {:ok, "1: one\n2: two"}
      assert Mapc.modify("1\n2", "5 b `iword; append %20x`", %Mappings{}) == {:ok, "one x\ntwo x"}
    end

    @errmsg "Mc.Modifier.Mapc#modify: 'concurrency' should be a positive integer"

    test "errors when `args` can't be parsed as a positive integer (max. 'cores to use' hint)" do
      assert Mapc.modify("", "", %Mappings{}) == {:error, @errmsg}
      assert Mapc.modify("", "not-an-integer", %Mappings{}) == {:error, @errmsg}
      assert Mapc.modify("", "1.2", %Mappings{}) == {:error, @errmsg}
      assert Mapc.modify("", "-2", %Mappings{}) == {:error, @errmsg}
      assert Mapc.modify("", "0", %Mappings{}) == {:error, @errmsg}
    end

    test "accepts 'concurrency' after whitespace" do
      assert Mapc.modify("foo\nbar", "\t2 ucase", %Mappings{}) == {:ok, "FOO\nBAR"}
      assert Mapc.modify("FOO\nBAR", "  4 lcase", %Mappings{}) == {:ok, "foo\nbar"}
    end

    test "reports errors" do
      assert Mapc.modify("FOO\nBAR", "2 error oops", %Mappings{}) == {:ok, "ERROR: oops\nERROR: oops"}

      assert Mapc.modify("1\n2", "4 nah", %Mappings{}) ==
        {:ok, "ERROR: modifier not found: nah\nERROR: modifier not found: nah"}
    end

    test "works with ok tuples" do
      assert Mapc.modify({:ok, "ONE\nTWO"}, "2 lcase", %Mappings{}) == {:ok, "one\ntwo"}
    end

    test "allows error tuples to pass through" do
      assert Mapc.modify({:error, "reason"}, "8 lcase", %Mappings{}) == {:error, "reason"}
    end
  end
end
