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
    %{mappings: %Mc.Mappings{}}
  end

  describe "modify/3" do
    test "'runs' the script referenced by 'key' on the `buffer`", %{mappings: mappings} do
      assert RunK.modify("stay in FOO contact", "s1", mappings) == {:ok, "stay in radio contact"}
      assert RunK.modify("one 4 da BASS", "s3", mappings) == {:ok, "one 4 da BASS"}
      assert RunK.modify("one 4 da BASS", "s2", mappings) == {:ok, "two 4 da treble"}
    end

    test "returns `buffer` when 'key' references a script that doesn't exist", %{mappings: mappings} do
      assert RunK.modify("still the same", "nope", mappings) == {:ok, "still the same"}
      assert RunK.modify("abc", "", mappings) == {:ok, "abc"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert RunK.modify({:ok, "FOO"}, "s1", mappings) == {:ok, "radio"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert RunK.modify({:error, "reason"}, "s2", mappings) == {:error, "reason"}
    end
  end
end
