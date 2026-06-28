defmodule Mc.Modifier.RunKTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.RunK

  setup do
    map = %{
      "s1" => "replace FOO RADIO\ncasel",
      "s2" => "casel\nreplace bass treble\nreplace one two",
      "s3" => "",
      "s4" => "range oops\nm rand 10",
    }

    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "reads `args` as a script key", do: true

    test "runs the script referenced by the key, against the `buffer`", %{mappings: mappings} do
      assert RunK.m("stay in FOO contact", "s1", mappings) == {:ok, "stay in radio contact"}
      assert RunK.m("one 4 da BASS", "s3", mappings) == {:ok, "one 4 da BASS"}
      assert RunK.m("one 4 da BASS", "s2", mappings) == {:ok, "two 4 da treble"}
    end

    test "errors when the key doesn't exist", %{mappings: mappings} do
      assert RunK.m("n/a", "nada", mappings) == {
        :error,
        Mc.Modifier.RunK,
        :key_not_found,
        "nada",
        [{Mc.Modifier.Get, :key_not_found, "nada"}]
      }
    end

    test "errors when the script errors", %{mappings: mappings} do
      assert RunK.m("", "s4", mappings) == {
        :error,
        Mc.Modifier.RunK,
        :script_error,
        "range oops\nm rand 10",
        [{Mc.Modifier.Range, :bad_limits, "oops"}]
      }
    end

    test "works with ok-tuples", %{mappings: mappings} do
      assert RunK.m({:ok, "FOO"}, "s1", mappings) == {:ok, "radio"}
    end

    test "allows error-tuples to pass through" do
      assert RunK.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
