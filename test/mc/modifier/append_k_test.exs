defmodule Mc.Modifier.AppendKTest do
  use ExUnit.Case, async: false

  alias Mc.Modifier.AppendK

  setup do
    map = %{"star" => "light", "thing" => "bar"}
    start_supervised({Mc.Adapter.KvMemory, map: map})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "parses `args` as a 'key' and appends its value to `buffer`", %{mappings: mappings} do
      assert AppendK.m("raise the ", "thing", mappings) == {:ok, "raise the bar"}
    end

    test "errors when the key doesn't exist", %{mappings: mappings} do
      assert AppendK.m("same", "nokey", mappings) == {
        :error,
        Mc.Modifier.AppendK,
        :key_not_found,
        "nokey",
        [{Mc.Modifier.Get, :key_not_found, "nokey"}]
      }
    end

    test "works with ok-tuples", %{mappings: mappings} do
      assert AppendK.m({:ok, "bright "}, "star", mappings) == {:ok, "bright light"}
    end

    test "allows error-tuples to pass through" do
      assert AppendK.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
