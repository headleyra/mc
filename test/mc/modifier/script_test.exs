defmodule Mc.Modifier.ScriptTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Script

  setup do
    start_supervised({Mc.Adapter.KvMemory, map: %{}})
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "parses `args` as: <sep> <1st line of script>{<sep> <2nd line of script script>}", do: true

    test "runs the script", %{mappings: mappings} do
      assert Script.m("", ", range 3, map prepend :, append -go", mappings) == {:ok, ":1\n:2\n:3-go"}
    end

    test "runs the script against `buffer`", %{mappings: mappings} do
      assert Script.m("foo", ". append -. append bar", mappings) == {:ok, "foo-bar"}
    end

    test "works with URI-encoded separators", %{mappings: mappings} do
      assert Script.m("bish", "%09 append -\t append bosh", mappings) == {:ok, "bish-bosh"}
    end

    test "returns script errors", %{mappings: mappings} do
      assert Script.m("", "; b dosh; error cash", mappings) == {
        :error,
        Mc.Modifier.Script,
        :script_error,
        "; b dosh; error cash",
        [{Mc.Modifier.Error, :error, "cash"}]
      }

      assert Script.m("", ", runk no-key", mappings) == {
        :error,
        Mc.Modifier.Script,
        :script_error,
        ", runk no-key",
        [
          {Mc.Modifier.RunK, :key_not_found, "no-key"},
          {Mc.Modifier.Get, :key_not_found, "no-key"}
        ]
      }
    end

    test "works with ok-tuples", %{mappings: mappings} do
      assert Script.m({:ok, "123"}, "/ prepend 0/ append 4", mappings) == {:ok, "01234"}
    end

    test "allows error-tuples to pass through" do
      assert Script.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
