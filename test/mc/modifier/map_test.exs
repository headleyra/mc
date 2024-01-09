defmodule Mc.Modifier.MapTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.Map

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{}})
    :ok
  end

  describe "modify/3" do
    test "parses `args` as a script and runs it against each line in `buffer` (synchronously)" do
      assert Map.modify("ApplE  JuicE", "casel", %Mc.Mappings{}) == {:ok, "apple  juice"}
      assert Map.modify("ApplE\nJuicE", "casel", %Mc.Mappings{}) == {:ok, "apple\njuice"}
      assert Map.modify("1\n2", "b `getb`: `getb; iword`", %Mc.Mappings{}) == {:ok, "1: one\n2: two"}
      assert Map.modify("1\n2", "b `iword; append %20x`", %Mc.Mappings{}) == {:ok, "one x\ntwo x"}
    end

    test "reports errors" do
      assert Map.modify("FOO\nBAR", "error oops", %Mc.Mappings{}) == {:ok, "ERROR: oops\nERROR: oops"}

      assert Map.modify("1\n2", "ex", %Mc.Mappings{}) ==
        {:ok, "ERROR: modifier not found: ex\nERROR: modifier not found: ex"}
    end

    test "works with ok tuples" do
      assert Map.modify({:ok, "bish\nbosh"}, "caseu", %Mc.Mappings{}) == {:ok, "BISH\nBOSH"}
    end

    test "allows error tuples to pass through" do
      assert Map.modify({:error, "reason"}, "casel", %Mc.Mappings{}) == {:error, "reason"}
    end
  end
end
