defmodule Mc.Modifier.RunkTest do
  use ExUnit.Case, async: false

  alias Mc.Client.Kv.Memory
  alias Mc.Modifier.Get
  alias Mc.Modifier.Runk

  setup do
    start_supervised({Memory, map: %{
      "s1" => "replace FOO RADIO\nlcase",
      "s2" => "lcase\nr bass treble\nr one two",
      "s3" => ""
    }, name: :mem})
    start_supervised({Get, kv_client: Memory, kv_pid: :mem})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Runk.modify/2" do
    test "'runs' the script referenced by 'key' on the `buffer`" do
      assert Runk.modify("stay in FOO contact", "s1") == {:ok, "stay in radio contact"}
      assert Runk.modify("one 4 da BASS", "s3") == {:ok, "one 4 da BASS"}
      assert Runk.modify("one 4 da BASS", "s2") == {:ok, "two 4 da treble"}
    end

    test "returns `buffer` when 'key' references a script that doesn't exist" do
      assert Runk.modify("still the same", "nope") == {:ok, "still the same"}
      assert Runk.modify("abc", "") == {:ok, "abc"}
    end

    test "works with ok tuples" do
      assert Runk.modify({:ok, "FOO"}, "s1") == {:ok, "radio"}
    end

    test "allows error tuples to pass through" do
      assert Runk.modify({:error, "reason"}, "s2") == {:error, "reason"}
    end
  end
end
