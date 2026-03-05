defmodule Mc.Modifier.MapTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.Map

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{}})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "run `args` against each line in `buffer` (sequentially)", %{mappings: mappings} do
      assert Map.m("ApplE  JuicE", "casel", mappings) == {:ok, "apple  juice"}
      assert Map.m("ApplE\nJuicE", "casel", mappings) == {:ok, "apple\njuice"}
      assert Map.m("1\n2", "b {getb}: {getb; iword}", mappings) == {:ok, "1: one\n2: two"}
      assert Map.m("1\n2", "b {iword; append -x}", mappings) == {:ok, "one-x\ntwo-x"}
    end

    test "reports errors", %{mappings: mappings} do
      assert Map.m("FOO\nBAR", "error oops", mappings) == {:ok, "ERROR: oops\nERROR: oops"}

      assert Map.m("1\n2", "ex", mappings) ==
        {:ok, "ERROR: modifier not found: ex\nERROR: modifier not found: ex"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert Map.m({:ok, "bish\nbosh"}, "caseu", mappings) == {:ok, "BISH\nBOSH"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert Map.m({:error, "reason"}, "casel", mappings) == {:error, "reason"}
    end
  end
end
