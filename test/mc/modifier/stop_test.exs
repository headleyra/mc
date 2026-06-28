defmodule Mc.Modifier.StopTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Stop

  setup do
    script = """
    buffer this
    stop
    buffer that
    """

    %{mappings: Mc.Mappings.standard(), script: script}
  end

  describe "m/3" do
    test "stops execution of a script and returns `buffer` at that point", %{mappings: mappings, script: script} do
      assert Mc.m(script, mappings) == {:ok, "this"}
    end

    test "works with ok-tuples" do
      assert Stop.m({:ok, "radio"}, "", %{}) == {:ok, "radio"}
    end

    test "allows error-tuples to pass through" do
      assert Stop.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
