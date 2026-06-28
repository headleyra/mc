defmodule Mc.Modifier.SetMTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.GetM
  alias Mc.Modifier.SetM

  @separator "\n---\n"

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{}})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "parses `buffer` as 'setm' format and sets keys/values as appropriate", do: true

    test "works with one key/value pair", %{mappings: mappings} do
      SetM.m("key-1\nvalue-1", "", mappings)
      assert Mc.m("get key-1", mappings) == {:ok, "value-1"}
    end

    test "defaults `args` to #{inspect(@separator)} and uses it to separate key/value pairs", %{mappings: mappings} do
      SetM.m("app\napple\tcore#{@separator}ten\ntennis\nball", "", mappings)
      assert Mc.m("get app", mappings) == {:ok, "apple\tcore"}
      assert Mc.m("get ten", mappings) == {:ok, "tennis\nball"}
    end

    test "accepts a URI-encoded separator", %{mappings: mappings} do
      SetM.m("five\ndata 5\n: :\tseven\nvalue 7", "%0a:%20:%09", mappings)
      assert Mc.m("get five", mappings) == {:ok, "data 5"}
      assert Mc.m("get seven", mappings) == {:ok, "value 7"}
    end

    test "complements the 'getm' modifier", %{mappings: mappings} do
      buffer = "key1\ndata one#{@separator}key2\nvalue two"
      SetM.m(buffer, "", mappings)
      assert GetM.m("key1 key2", "", mappings) == {:ok, buffer}

      buffer = "key7\nseven:::key8\neight"
      SetM.m(buffer, ":::", mappings)
      assert GetM.m("key7 key8", ":::", mappings) == {:ok, buffer}
    end

    test "returns `buffer`", %{mappings: mappings} do
      buffer = "k1\nv1-k2\nv2"
      {:ok, result} = SetM.m(buffer, "-", mappings)
      assert result == buffer
    end

    @err {:error, Mc.Modifier.SetM, :bad_setm_format, nil, []}

    test "errors when the 'setm' format is bad", %{mappings: mappings} do
      assert SetM.m("key-with-no-value", "", mappings) == @err
      assert SetM.m("key\nvalue#{@separator}key-with-no-value", "", mappings) == @err
    end

    test "works with ok-tuples", %{mappings: mappings} do
      SetM.m({:ok, "cash\nmoney"}, "", mappings)
      assert Mc.m("get cash", mappings) == {:ok, "money"}
    end

    test "allows error-tuples to pass through" do
      assert SetM.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
