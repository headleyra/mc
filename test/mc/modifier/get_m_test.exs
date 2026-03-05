defmodule Mc.Modifier.GetMTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.GetM

  @default_separator "\n---\n"

  setup do
    map = %{
      "key1" => "data one",
      "key2" => "value\ntwo\n"
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "parses `buffer` as whitespace-separated keys and expands them into 'setm' format", do: true
    test "assumes `separator` is '#{@default_separator}' when it's an empty string", do: true
    test "expects `mappings` to contain a 'KV' modifier called `get`", do: true

    test "parses the `buffer`", %{mappings: mappings} do
      assert GetM.m("key1 key2", "", mappings) ==
        {:ok, "key1\ndata one#{@default_separator}key2\nvalue\ntwo\n"}

      assert GetM.m("key2 key1", "", mappings) ==
        {:ok, "key2\nvalue\ntwo\n#{@default_separator}key1\ndata one"}

      assert GetM.m("key1", "", mappings) == {:ok, "key1\ndata one"}
      assert GetM.m(" key1\t\n", "", mappings) == {:ok, "key1\ndata one"}
      assert GetM.m("no-exist", "", mappings) == {:ok, "no-exist\n"}

      assert GetM.m("no-exist.1 no-exist.2", "", mappings) ==
        {:ok, "no-exist.1\n#{@default_separator}no-exist.2\n"}
    end

    test "accepts a URI-encoded separator", %{mappings: mappings} do
      assert GetM.m("key1 key2", "; ", mappings) == {:ok, "key1\ndata one; key2\nvalue\ntwo\n"}
      assert GetM.m("key1 key2", " -%09: ", mappings) == {:ok, "key1\ndata one -\t: key2\nvalue\ntwo\n"}
      assert GetM.m("key1", "; ", mappings) == {:ok, "key1\ndata one"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert GetM.m({:ok, "key1"}, "", mappings) == {:ok, "key1\ndata one"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert GetM.m({:error, "reason"}, "", mappings) == {:error, "reason"}
    end
  end
end
