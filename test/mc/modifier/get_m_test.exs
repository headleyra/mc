defmodule Mc.Modifier.GetMTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.GetM

  @separator "\n---\n"

  setup do
    map = %{
      "key1" => "data one",
      "key2" => "value\ntwo\n"
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "parses `buffer` as a whitespace-separated list of keys and expands them into 'setm' format", do: true

    test "works with one key", %{mappings: mappings} do
      assert GetM.m("key1", "", mappings) == {:ok, "key1\ndata one"}
      assert GetM.m(" key1\t\n", "", mappings) == {:ok, "key1\ndata one"}
      assert GetM.m("no-exist", "", mappings) == {:ok, "no-exist\n"}
      assert GetM.m("key2", "", mappings) == {:ok, "key2\nvalue\ntwo\n"}
    end

    test "defaults `args` to #{inspect(@separator)} and uses it to separate key/value pairs", %{mappings: mappings} do
      assert GetM.m("key1 key2", "", mappings) == {:ok, "key1\ndata one#{@separator}key2\nvalue\ntwo\n"}
      assert GetM.m("key2 key1", "", mappings) == {:ok, "key2\nvalue\ntwo\n#{@separator}key1\ndata one"}
      assert GetM.m("no-exist.1 no-exist.2", "", mappings) == {:ok, "no-exist.1\n#{@separator}no-exist.2\n"}
    end

    test "accepts a URI-encoded separator", %{mappings: mappings} do
      assert GetM.m("key1 key2", ":%0a-%09:", mappings) == {:ok, "key1\ndata one:\n-\t:key2\nvalue\ntwo\n"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert GetM.m({:ok, "key1"}, "", mappings) == {:ok, "key1\ndata one"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert GetM.m({:error, "reason"}, "", mappings) == {:error, "reason"}
    end
  end
end
