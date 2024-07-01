defmodule Mc.Modifier.MapTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.Map

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{}})
    %{mappings: %Mc.Mappings{}}
  end

  describe "modify/3" do
    test "run `args` against each line in `buffer` (sequentially)", %{mappings: mappings} do
      assert Map.modify("ApplE  JuicE", "casel", mappings) == {:ok, "apple  juice"}
      assert Map.modify("ApplE\nJuicE", "casel", mappings) == {:ok, "apple\njuice"}
      assert Map.modify("1\n2", "b {getb}: {getb; iword}", mappings) == {:ok, "1: one\n2: two"}
      assert Map.modify("1\n2", "b {iword; append -x}", mappings) == {:ok, "one-x\ntwo-x"}
    end

    test "reports errors", %{mappings: mappings} do
      assert Map.modify("FOO\nBAR", "error oops", mappings) == {:ok, "ERROR: oops\nERROR: oops"}

      assert Map.modify("1\n2", "ex", mappings) ==
        {:ok, "ERROR: modifier not found: ex\nERROR: modifier not found: ex"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert Map.modify({:ok, "bish\nbosh"}, "caseu", mappings) == {:ok, "BISH\nBOSH"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert Map.modify({:error, "reason"}, "casel", mappings) == {:error, "reason"}
    end
  end
end
