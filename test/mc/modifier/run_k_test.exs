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
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "runs the script referenced by key, against the `buffer`", %{mappings: mappings} do
      assert RunK.m("stay in FOO contact", "s1", mappings) == {:ok, "stay in radio contact"}
      assert RunK.m("one 4 da BASS", "s3", mappings) == {:ok, "one 4 da BASS"}
      assert RunK.m("one 4 da BASS", "s2", mappings) == {:ok, "two 4 da treble"}
    end

    test "errors when the key doesn't exist", %{mappings: mappings} do
      assert RunK.m("n/a", "nope", mappings) == {:error, "Mc.Modifier.RunK: Mc.Modifier.Get: not found: nope"}
      assert RunK.m("abc", "", mappings) == {:error, "Mc.Modifier.RunK: Mc.Modifier.Get: not found: "}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert RunK.m({:ok, "FOO"}, "s1", mappings) == {:ok, "radio"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert RunK.m({:error, "reason"}, "s2", mappings) == {:error, "reason"}
    end
  end
end
