defmodule Mc.Modifier.GetMTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.GetM

  @default_separator "\n---\n"

  defmodule Mappings do
    defstruct [
      get: Mc.Modifier.Get
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

  describe "modify/3" do
    test "parses `buffer` as whitespace-separated keys and expands them into 'setm' format", do: true
    test "assumes `separator` is '#{@default_separator}' when it's an empty string", do: true
    test "expects `mappings` to contain a 'KV' modifier called `get`", do: true

    test "parses the `buffer`" do
      assert GetM.modify("key1 key2", "", %Mappings{}) ==
        {:ok, "key1\ndata one#{@default_separator}key2\nvalue\ntwo\n"}

      assert GetM.modify("key2 key1", "", %Mappings{}) ==
        {:ok, "key2\nvalue\ntwo\n#{@default_separator}key1\ndata one"}

      assert GetM.modify("key1", "", %Mappings{}) == {:ok, "key1\ndata one"}
      assert GetM.modify(" key1\t\n", "", %Mappings{}) == {:ok, "key1\ndata one"}
      assert GetM.modify("no-exist", "", %Mappings{}) == {:ok, "no-exist\n"}

      assert GetM.modify("no-exist.1 no-exist.2", "", %Mappings{}) ==
        {:ok, "no-exist.1\n#{@default_separator}no-exist.2\n"}
    end

    test "accepts a URI-encoded separator" do
      assert GetM.modify("key1 key2", "; ", %Mappings{}) == {:ok, "key1\ndata one; key2\nvalue\ntwo\n"}
      assert GetM.modify("key1 key2", " -%09: ", %Mappings{}) == {:ok, "key1\ndata one -\t: key2\nvalue\ntwo\n"}
      assert GetM.modify("key1", "; ", %Mappings{}) == {:ok, "key1\ndata one"}
    end

    test "works with ok tuples" do
      assert GetM.modify({:ok, "key1"}, "", %Mappings{}) == {:ok, "key1\ndata one"}
    end

    test "allows error tuples to pass through" do
      assert GetM.modify({:error, "reason"}, "", %Mappings{}) == {:error, "reason"}
    end
  end
end
