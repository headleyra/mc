defmodule Mc.Modifier.MapTest do
  use ExUnit.Case, async: false

  alias Mc.Adapter.KvMemory
  alias Mc.Modifier.Map

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
    test "parses `args` as a script and runs it against each line in `buffer`" do
      assert Map.modify("ApplE  JuicE", "lcase", %Mappings{}) == {:ok, "apple  juice"}
      assert Map.modify("ApplE\nJuicE", "lcase", %Mappings{}) == {:ok, "apple\njuice"}
      assert Map.modify("1\n2", "b `getb`: `getb; iword`", %Mappings{}) == {:ok, "1: one\n2: two"}
      assert Map.modify("1\n2", "b `iword; append %20x`", %Mappings{}) == {:ok, "one x\ntwo x"}
    end

    test "reports errors" do
      assert Map.modify("FOO\nBAR", "error oops", %Mappings{}) == {:ok, "ERROR: oops\nERROR: oops"}
      assert Map.modify("1\n2", "ex", %Mappings{}) == {:ok, "ERROR: modifier not found: ex\nERROR: modifier not found: ex"}
    end

    test "works with ok tuples" do
      assert Map.modify({:ok, "bish\nbosh"}, "ucase", %Mappings{}) == {:ok, "BISH\nBOSH"}
    end

    test "allows error tuples to pass through" do
      assert Map.modify({:error, "reason"}, "lcase", %Mappings{}) == {:error, "reason"}
    end
  end
end
