defmodule Mc.Modifier.SetMTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.GetM
  alias Mc.Modifier.SetM

  @default_separator "\n---\n"

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{}})
    :ok
  end

  describe "modify/3" do
    test "parses `buffer` as 'setm' format and sets keys/values as appropriate", do: true
    test "assumes `separator` is '#{@default_separator}' when it's an empty string", do: true
    test "expects `mappings` to contain a 'KV' modifier called `set`", do: true

    test "parses the `buffer`" do
      SetM.modify("key\nvalue", "", %Mc.Mappings{})
      assert Mc.Modifier.Get.modify("", "key", %{}) == {:ok, "value"}

      SetM.modify("app\napple\tcore#{@default_separator}ten\ntennis\nball", "", %Mc.Mappings{})
      assert Mc.Modifier.Get.modify("", "app", %{}) == {:ok, "apple\tcore"}
      assert Mc.Modifier.Get.modify("", "ten", %{}) == {:ok, "tennis\nball"}
    end

    test "accepts a URI-encoded separator" do
      SetM.modify("five\ndata 5* -\t@:seven\nvalue 7", "*%20-%09@:", %Mc.Mappings{})
      assert Mc.Modifier.Get.modify("", "five", %{}) == {:ok, "data 5"}
      assert Mc.Modifier.Get.modify("", "seven", %{}) == {:ok, "value 7"}
    end

    test "complements the 'getm' modifier" do
      setm1 = "key1\ndata one#{@default_separator}key2\nvalue two"
      SetM.modify(setm1, "", %Mc.Mappings{})
      assert GetM.modify("key1 key2", "", %Mc.Mappings{}) == {:ok, setm1}

      setm2 = "key7\nseven:::key8\neight"
      SetM.modify(setm2, ":::", %Mc.Mappings{})
      assert GetM.modify("key7 key8", ":::", %Mc.Mappings{}) == {:ok, setm2}
    end

    test "errors when the 'setm' format is bad" do
      assert SetM.modify("key-with-no-value", "", %Mc.Mappings{}) == {:error, "Mc.Modifier.SetM: bad format"}

      assert SetM.modify("key\nvalue#{@default_separator}key-with-no-value", "", %Mc.Mappings{}) ==
        {:error, "Mc.Modifier.SetM: bad format"}
    end

    test "works with ok tuples" do
      SetM.modify({:ok, "cash\ndosh"}, "", %Mc.Mappings{})
      assert Mc.Modifier.Get.modify("", "cash", %{}) == {:ok, "dosh"}
    end

    test "allows error tuples to pass through" do
      assert SetM.modify({:error, "reason"}, "", %Mc.Mappings{}) == {:error, "reason"}
    end
  end
end
