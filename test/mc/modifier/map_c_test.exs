defmodule Mc.Modifier.MapCTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.MapC

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{}})
    %{mappings: %Mc.Mappings{}}
  end

  describe "modify/3" do
    test "run `args` against each line in `buffer` (integer is concurrency)", %{mappings: mappings} do
      assert MapC.modify("ApplE  JuicE", "1 casel", mappings) == {:ok, "apple  juice"}
      assert MapC.modify("ApplE\nJuicE", "2 casel", mappings) == {:ok, "apple\njuice"}
      assert MapC.modify("1\n2", "3 b `getb`: `getb; iword`", mappings) == {:ok, "1: one\n2: two"}
      assert MapC.modify("1\n2", "5 b `iword; append -x`", mappings) == {:ok, "one-x\ntwo-x"}
    end

    @errmsg "Mc.Modifier.MapC: 'concurrency' should be a positive integer"

    test "errors on bad concurrency (max. 'cores to use' hint)", %{mappings: mappings} do
      assert MapC.modify("", "", mappings) == {:error, @errmsg}
      assert MapC.modify("", "not-an-integer", mappings) == {:error, @errmsg}
      assert MapC.modify("", "1.2", mappings) == {:error, @errmsg}
      assert MapC.modify("", "-2", mappings) == {:error, @errmsg}
      assert MapC.modify("", "0", mappings) == {:error, @errmsg}
    end

    test "accepts 'concurrency' after whitespace", %{mappings: mappings} do
      assert MapC.modify("foo\nbar", "\t2 caseu", mappings) == {:ok, "FOO\nBAR"}
      assert MapC.modify("FOO\nBAR", "  4 casel", mappings) == {:ok, "foo\nbar"}
    end

    test "reports errors", %{mappings: mappings} do
      assert MapC.modify("FOO\nBAR", "2 error oops", mappings) == {:ok, "ERROR: oops\nERROR: oops"}

      assert MapC.modify("1\n2", "4 nah", mappings) ==
        {:ok, "ERROR: modifier not found: nah\nERROR: modifier not found: nah"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert MapC.modify({:ok, "ONE\nTWO"}, "2 casel", mappings) == {:ok, "one\ntwo"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert MapC.modify({:error, "reason"}, "8 casel", mappings) == {:error, "reason"}
    end
  end
end
