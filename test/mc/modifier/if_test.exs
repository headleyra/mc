defmodule Mc.Modifier.IfTest do
  use ExUnit.Case, async: false

  alias Mc.Client.Kv.Memory
  alias Mc.Modifier.Get
  alias Mc.Modifier.If

  setup do
    start_supervised({Memory, map: %{"key1" => "BUFFER THIS", "key2" => "lcase", "key3" => "append festival"}})
    start_supervised({Get, kv_client: Memory})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.If.modify/2" do
    test "runs 'value of key2' if `buffer` equals 'value of key1' else runs 'value of key3'" do
      assert If.modify("BUFFER THIS", "key1 key2 key3") == {:ok, "buffer this"}
      assert If.modify("london bridge ", "keya key2 key3") == {:ok, "london bridge festival"}
    end

    test "errors without exactly 3 keys" do
      assert If.modify("fiscal rules", "") ==
        {:error, "usage: Mc.Modifier.If#modify <compare key> <true key> <false key>"}

      assert If.modify("gig economy", "one") ==
        {:error, "usage: Mc.Modifier.If#modify <compare key> <true key> <false key>"}

      assert If.modify("yaba daba do", "buy the dip dude") ==
        {:error, "usage: Mc.Modifier.If#modify <compare key> <true key> <false key>"}
    end

    test "returns a help message" do
      assert Check.has_help?(If, :modify)
    end

    test "errors with unknown switches" do
      assert If.modify("", "--unknown") == {:error, "Mc.Modifier.If#modify: switch parse error"}
      assert If.modify("", "-u") == {:error, "Mc.Modifier.If#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert If.modify({:ok, "aaa "}, "key1 key2 key3") == {:ok, "aaa festival"}
    end

    test "allows error tuples to pass through" do
      assert If.modify({:error, "reason"}, "na") == {:error, "reason"}
    end
  end
end
