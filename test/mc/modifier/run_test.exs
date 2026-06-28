defmodule Mc.Modifier.RunTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Run

  setup do
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "treats `buffer` as a script and 'runs' it", %{mappings: mappings} do
      assert Run.m("buffer FOO\ncasel", "", mappings) == {:ok, "foo"}
      assert Run.m("buffer BAR\ncasel", "n/a", mappings) == {:ok, "bar"}
    end

    test "returns the first error encountered", %{mappings: mappings} do
      assert Run.m("error boom", "", mappings) == {
        :error,
        Mc.Modifier.Run,
        :script_error,
        "error boom",
        [{Mc.Modifier.Error, :error, "boom"}]
      }

      assert Run.m("range 1st 5th", "", mappings) == {
        :error,
        Mc.Modifier.Run,
        :script_error,
        "range 1st 5th",
        [{Mc.Modifier.Range, :bad_limits, "1st 5th"}]
      }
    end

    test "works with ok-tuples", %{mappings: mappings} do
      assert Run.m({:ok, "buffer Look\nreplace L B"}, "", mappings) == {:ok, "Book"}
    end

    test "allows error-tuples to pass through" do
      assert Run.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
