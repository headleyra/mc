defmodule Mc.Modifier.RunTest do
  use ExUnit.Case, async: false

  alias Mc.Client.Kv.Memory
  alias Mc.Modifier.Get
  alias Mc.Modifier.Run

  setup do
    start_supervised({Memory, map: %{
      "s1" => "replace FOO RADIO\nlcase",
      "s2" => "lcase\nr bass treble\nr one two",
      "s3" => ""
    }})
    start_supervised({Get, kv_client: Memory})
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Run.modify/2" do
    test "treats `buffer` as a script and 'runs' it" do
      assert Run.modify("buffer FOO\nlcase", "") == {:ok, "foo"}
      assert Run.modify("buffer BAR\nlcase", "n/a") == {:ok, "bar"}
    end

    test "'runs' the script referenced by 'key' on the `buffer` ('key' switch)" do
      assert Run.modify("stay in FOO contact", "--key s1") == {:ok, "stay in radio contact"}
      assert Run.modify("one 4 da BASS", "-k s2") == {:ok, "two 4 da treble"}
      assert Run.modify("one 4 da BASS", "-k s3") == {:ok, "one 4 da BASS"}
    end

    test "returns `buffer` intact, when 'key' references a script that doesn't exist ('key' switch)" do
      assert Run.modify("still the same", "-k nope") == {:ok, "still the same"}
    end

    test "errors when no key is given ('key' switch)" do
      assert Run.modify("", "--key") == {:error, "Mc.Modifier.Run#modify: switch parse error"}
      assert Run.modify("", "-k") == {:error, "Mc.Modifier.Run#modify: switch parse error"}
    end

    test "returns a help message" do
      assert Check.has_help?(Run, :modify)
    end

    test "errors with unknown switches" do
      assert Run.modify("", "--unknown") == {:error, "Mc.Modifier.Run#modify: switch parse error"}
      assert Run.modify("", "-u") == {:error, "Mc.Modifier.Run#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Run.modify({:ok, "buffer Look\nreplace L B"}, "") == {:ok, "Book"}
      assert Run.modify({:ok, "FOO"}, "-k s1") == {:ok, "radio"}
    end

    test "allows error tuples to pass through" do
      assert Run.modify({:error, "reason"}, "") == {:error, "reason"}
      assert Run.modify({:error, "reason"}, "-k s2") == {:error, "reason"}
    end
  end
end
