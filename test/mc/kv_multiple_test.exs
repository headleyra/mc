defmodule Mc.KvMultipleTest do
  use ExUnit.Case, async: false
  alias Mc.KvMultiple

  @default_separator "\n---\n"

  setup do
    map = %{
      "key1" => "data one",
      "key2" => "value\ntwo\n"
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: %Mc.Mappings{}}
  end

  describe "get/3" do
    test "parses `keys` as a set of whitespace-separated keys and expands them into 'setm' format", do: true
    test "assumes `separator` is #{inspect(@default_separator)} when it's an empty string", do: true
    test "expects `mappings` to contain a 'KV' modifier called `get`", do: true

    test "expands multiple keys", %{mappings: mappings} do
      assert KvMultiple.get("key1 key2", "", mappings) ==
        {:ok, "key1\ndata one#{@default_separator}key2\nvalue\ntwo\n"}

      assert KvMultiple.get("key1", "", mappings) == {:ok, "key1\ndata one"}

      assert KvMultiple.get("key2\nkey1", "", mappings) ==
        {:ok, "key2\nvalue\ntwo\n#{@default_separator}key1\ndata one"}

      assert KvMultiple.get("  key1\t\n", "", mappings) == {:ok, "key1\ndata one"}
      assert KvMultiple.get("no.exist", "", mappings) == {:ok, "no.exist\n"}

      assert KvMultiple.get("no-exist-1 no-exist-2", "", mappings) ==
        {:ok, "no-exist-1\n#{@default_separator}no-exist-2\n"}
    end

    test "accepts a URI-encoded `separator`", %{mappings: mappings} do
      assert KvMultiple.get("key1 key2", ":%20:", mappings) == {:ok, "key1\ndata one: :key2\nvalue\ntwo\n"}
      assert KvMultiple.get("key1 key2", "*%09*", mappings) == {:ok, "key1\ndata one*\t*key2\nvalue\ntwo\n"}
    end

    test "ignores the separator if there's only one key", %{mappings: mappings} do
      assert KvMultiple.get("key1", "==", mappings) == {:ok, "key1\ndata one"}
    end
  end

  describe "set/3" do
    test "parses `setm` as 'setm' format and sets keys/values as appropriate", do: true
    test "assumes `separator` is #{inspect(@default_separator)} when it's an empty string", do: true
    test "expects `mappings` to contain a 'KV' modifier called `set`", do: true
    test "complements get/3", do: true

    test "sets multiple keys and values", %{mappings: mappings} do
      KvMultiple.set("k1\nv1#{@default_separator}k2\nv2", "", %Mc.Mappings{})
      assert KvMultiple.get("k1 k2", "", mappings) == {:ok, "k1\nv1#{@default_separator}k2\nv2"}

      KvMultiple.set("k3\nv3", "", %Mc.Mappings{})
      assert KvMultiple.get("k3", "", mappings) == {:ok, "k3\nv3"}
    end

    test "accepts a URI-encoded `separator`", %{mappings: mappings} do
      KvMultiple.set("k1\nv1:\t:k2\nv2", ":%09:", %Mc.Mappings{})
      assert KvMultiple.get("k1 k2", ":%09:", mappings) == {:ok, "k1\nv1:\t:k2\nv2"}

      KvMultiple.set("key5\nval5: :key7\nval7", ":%20:", %Mc.Mappings{})
      assert KvMultiple.get("key5 key7", "*%20*", mappings) == {:ok, "key5\nval5* *key7\nval7"}
    end

    test "errors when the 'setm' format is bad", %{mappings: mappings} do
      assert KvMultiple.set("bad-format", "", mappings) == {:error, "bad format"}
      assert KvMultiple.set("   ", "", mappings) == {:error, "bad format"}
      assert KvMultiple.set("\t", "", mappings) == {:error, "bad format"}
      assert KvMultiple.set("key\nvalue#{@default_separator}key-only", "", mappings) == {:error, "bad format"}
    end
  end

  describe "list/2" do
    test "parses `keys` as a whitespace-separated keys; return list: key/value tuples", %{mappings: mappings} do
      assert KvMultiple.list("key1 key2", mappings) == [{"key1", "data one"}, {"key2", "value\ntwo\n"}]
      assert KvMultiple.list("key1", mappings) == [{"key1", "data one"}]
      assert KvMultiple.list("key2\nkey1", mappings) == [{"key2", "value\ntwo\n"}, {"key1", "data one"}]
      assert KvMultiple.list("  key1\t\n", mappings) == [{"key1", "data one"}]
      assert KvMultiple.list("no.exist", mappings) == [{"no.exist", ""}]
      assert KvMultiple.list("ne1 ne2", mappings) == [{"ne1", ""}, {"ne2", ""}]
    end
  end
end
