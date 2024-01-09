defmodule Mc.Modifier.RunKTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.RunK

  setup do
    map =
      %{
        "s1" => "replace FOO RADIO\ncasel",
        "s2" => "casel\nreplace bass treble\nreplace one two",
        "s3" => ""
      }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    :ok
  end

  describe "modify/3" do
    test "'runs' the script referenced by 'key' on the `buffer`" do
      assert RunK.modify("stay in FOO contact", "s1", %Mc.Mappings{}) == {:ok, "stay in radio contact"}
      assert RunK.modify("one 4 da BASS", "s3", %Mc.Mappings{}) == {:ok, "one 4 da BASS"}
      assert RunK.modify("one 4 da BASS", "s2", %Mc.Mappings{}) == {:ok, "two 4 da treble"}
    end

    test "returns `buffer` when 'key' references a script that doesn't exist" do
      assert RunK.modify("still the same", "nope", %Mc.Mappings{}) == {:ok, "still the same"}
      assert RunK.modify("abc", "", %Mc.Mappings{}) == {:ok, "abc"}
    end

    test "works with ok tuples" do
      assert RunK.modify({:ok, "FOO"}, "s1", %Mc.Mappings{}) == {:ok, "radio"}
    end

    test "allows error tuples to pass through" do
      assert RunK.modify({:error, "reason"}, "s2", %Mc.Mappings{}) == {:error, "reason"}
    end
  end
end
