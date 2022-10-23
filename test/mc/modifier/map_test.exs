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
    test "parses `args` as a script and runs it against each line in `buffer`" do
      assert Map.modify("ApplE  JuicE", "lcase") == {:ok, "apple  juice"}
      assert Map.modify("ApplE\nJuicE", "lcase") == {:ok, "apple\njuice"}
      assert Map.modify("1\n2", "b `getb`: `getb; iword`") == {:ok, "1: one\n2: two"}
      assert Map.modify("1\n2", "b `iword; append %20x`") == {:ok, "one x\ntwo x"}
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
