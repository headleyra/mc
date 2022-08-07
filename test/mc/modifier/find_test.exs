defmodule Mc.Modifier.FindTest do
  use ExUnit.Case, async: false
  alias Mc.Client.Kv.Memory
  alias Mc.Modifier.Find

  setup do
    start_supervised({Memory, map: %{"1st" => "foo", "2nd" => "foobar", "3rd" => "dosh"}})
    start_supervised({Find, kv_client: Memory})
    :ok
  end

  describe "Mc.Modifier.Find.modify/2" do
    test "returns the KV client implementation" do
      assert Find.kv_client() == Memory
    end

    test "finds keys matching the given regex" do
      assert Find.modify("n/a", "rd") == {:ok, "3rd"}
      assert Find.modify("", "d") == {:ok, "2nd\n3rd"}
      assert Find.modify("", ".") == {:ok, "1st\n2nd\n3rd"}
      assert Find.modify("", "") == {:ok, "1st\n2nd\n3rd"}
    end

    test "finds keys with values matching the given regex ('value' switch)" do
      assert Find.modify("n/a", "--value os") == {:ok, "3rd"}
      assert Find.modify("", "-v foo") == {:ok, "1st\n2nd"}
      assert Find.modify("", "-v") == {:ok, "1st\n2nd\n3rd"}
    end

    test "errors when the regex is bad" do
      assert Find.modify("", "?") == {:error, "Mc.Modifier.Find#modify: bad regex"}
      assert Find.modify("", "-v *") == {:error, "Mc.Modifier.Find#modify: bad regex"}
    end

    test "returns a help message" do
      assert Check.has_help?(Find, :modify)
    end

    test "errors with unknown switches" do
      assert Find.modify("", "--unknown") == {:error, "Mc.Modifier.Find#modify: switch parse error"}
      assert Find.modify("", "-u") == {:error, "Mc.Modifier.Find#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Find.modify({:ok, "n/a"}, "2") == {:ok, "2nd"}
      assert Find.modify({:ok, ""}, "-v dosh") == {:ok, "3rd"}
    end

    test "allows error tuples to pass through" do
      assert Find.modify({:error, "reason"}, "key") == {:error, "reason"}
      assert Find.modify({:error, "reason"}, "-v key") == {:error, "reason"}
    end
  end
end
