defmodule Mc.KvMultipleTest do
  use ExUnit.Case, async: false
  alias Mc.KvMultiple

  @default_separator "\n---\n"

  defmodule Mappings do
    defstruct [
      get: Mc.Modifier.Get,
      set: Mc.Modifier.Set
    ]
  end

  setup do
    map = %{
      "key1" => "data one",
      "key2" => "value\ntwo\n"
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    :ok
  end

  describe "getm/3" do
    test "parses `string` as a set of whitespace-separated keys and expands them into 'setm' format", do: true
    test "assumes `separator` is '#{@default_separator}' when it's an empty string", do: true
    test "expects `mappings` to contain a 'KV' modifier called `get`", do: true

    test "gets multiple keys" do
      assert KvMultiple.get("key1 key2", "", %Mappings{}) ==
        {:ok, "key1\ndata one#{@default_separator}key2\nvalue\ntwo\n"}

      assert KvMultiple.get("key1", "", %Mappings{}) == {:ok, "key1\ndata one"}

      assert KvMultiple.get("key2\nkey1", "", %Mappings{}) ==
        {:ok, "key2\nvalue\ntwo\n#{@default_separator}key1\ndata one"}

      assert KvMultiple.get("  key1\t\n", "", %Mappings{}) == {:ok, "key1\ndata one"}
      assert KvMultiple.get("no.exist", "", %Mappings{}) == {:ok, "no.exist\n"}

      assert KvMultiple.get("no-exist-1 no-exist-2", "", %Mappings{}) ==
        {:ok, "no-exist-1\n#{@default_separator}no-exist-2\n"}
    end

    test "accepts a URI-encoded `separator`" do
      assert KvMultiple.get("key1 key2", ":%20:", %Mappings{}) == {:ok, "key1\ndata one: :key2\nvalue\ntwo\n"}
      assert KvMultiple.get("key1 key2", "*%09*", %Mappings{}) == {:ok, "key1\ndata one*\t*key2\nvalue\ntwo\n"}
    end

    test "ignores the separator if there's only one key" do
      assert KvMultiple.get("key1", "==", %Mappings{}) == {:ok, "key1\ndata one"}
    end
  end

  describe "set/3" do
    test "parses `string` as 'setm' format and sets keys/values as appropriate", do: true
    test "assumes `separator` is '#{@default_separator}' when it's an empty string", do: true
    test "expects `mappings` to contain a 'KV' modifier called `set`", do: true
    test "complements get/3", do: true

    test "sets multiple keys and values" do
      KvMultiple.set("k1\nv1#{@default_separator}k2\nv2", "", %Mappings{})
      assert KvMultiple.get("k1 k2", "", %Mappings{}) == {:ok, "k1\nv1#{@default_separator}k2\nv2"}

      KvMultiple.set("k3\nv3", "", %Mappings{})
      assert KvMultiple.get("k3", "", %Mappings{}) == {:ok, "k3\nv3"}
    end

    test "accepts a URI-encoded `separator`" do
      KvMultiple.set("k1\nv1:\t:k2\nv2", ":%09:", %Mappings{})
      assert KvMultiple.get("k1 k2", ":%09:", %Mappings{}) == {:ok, "k1\nv1:\t:k2\nv2"}

      KvMultiple.set("key5\nval5: :key7\nval7", ":%20:", %Mappings{})
      assert KvMultiple.get("key5 key7", "*%20*", %Mappings{}) == {:ok, "key5\nval5* *key7\nval7"}
    end

    test "errors when the 'setm' format is bad" do
      assert KvMultiple.set("bad-format", "", %Mappings{}) == {:error, "bad format"}
      assert KvMultiple.set("   ", "", %Mappings{}) == {:error, "bad format"}
      assert KvMultiple.set("\t", "", %Mappings{}) == {:error, "bad format"}
      assert KvMultiple.set("key\nvalue#{@default_separator}key-only", "", %Mappings{}) == {:error, "bad format"}
    end
  end
end
