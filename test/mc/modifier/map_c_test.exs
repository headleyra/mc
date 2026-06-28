defmodule Mc.Modifier.MapCTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.MapC

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{}})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "parses `args` as: <max concurrency> <single-line script>", do: true
    test "uses <max concurrency> as a hint to the system to use that many CPU cores", do: true

    test "runs the script against each line in `buffer`", %{mappings: mappings} do
      assert MapC.m("ApplE  JuicE", "1 casel", mappings) == {:ok, "apple  juice"}
      assert MapC.m("ApplE\nJuicE", "2 casel", mappings) == {:ok, "apple\njuice"}
      assert MapC.m("1\n2", "3 b {getb}: {getb; iword}", mappings) == {:ok, "1: one\n2: two"}
      assert MapC.m("1\n2", "5 b {iword; append -x}", mappings) == {:ok, "one-x\ntwo-x"}
    end

    test "errors when concurrency isn't a positive integer", %{mappings: mappings} do
      assert MapC.m("", "", mappings) == {:error, Mc.Modifier.MapC, :bad_concurrency, "", []}
      assert MapC.m("", "not-int", mappings) == {:error, Mc.Modifier.MapC, :bad_concurrency, "not-int", []}
      assert MapC.m("", "1.2", mappings) == {:error, Mc.Modifier.MapC, :bad_concurrency, "1.2", []}
      assert MapC.m("", "-2", mappings) == {:error, Mc.Modifier.MapC, :bad_concurrency, "-2", []}
      assert MapC.m("", "0", mappings) == {:error, Mc.Modifier.MapC, :bad_concurrency, "0", []}
    end

    test "accepts concurrency after whitespace", %{mappings: mappings} do
      assert MapC.m("foo\nbar", "\t2 caseu", mappings) == {:ok, "FOO\nBAR"}
      assert MapC.m("FOO\nBAR", "  4 casel", mappings) == {:ok, "foo\nbar"}
    end

    test "reports errors", %{mappings: mappings} do
      assert MapC.m("FOO\nBAR", "2 error oops", mappings) == {:ok, "ERROR: oops\nERROR: oops"}
      assert MapC.m("1\n2", "4 nah", mappings) == {:ok, "ERROR: modifier unknown: nah\nERROR: modifier unknown: nah"}
    end

    test "works with ok-tuples", %{mappings: mappings} do
      assert MapC.m({:ok, "ONE\nTWO"}, "2 casel", mappings) == {:ok, "one\ntwo"}
    end

    test "allows error-tuples to pass through" do
      assert MapC.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
