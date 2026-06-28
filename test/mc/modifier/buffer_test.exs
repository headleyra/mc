defmodule Mc.Modifier.BufferTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Buffer

  setup do
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "returns `args`", %{mappings: mappings} do
      assert Buffer.m("n/a", "these are some args", mappings) == {:ok, "these are some args"}
      assert Buffer.m("", "NWO\nIMF\nWHO\nWTO", mappings) == {:ok, "NWO\nIMF\nWHO\nWTO"}
      assert Buffer.m("foo", "", mappings) == {:ok, ""}
      assert Buffer.m("", "will not split into;lines", mappings) == {:ok, "will not split into;lines"}
      assert Buffer.m("", "foo;bar;", mappings) == {:ok, "foo;bar;"}
    end

    test "parses `args` as an 'inline string'", %{mappings: mappings} do
      assert Buffer.m("", "will split into; lines", mappings) == {:ok, "will split into\nlines"}
      assert Buffer.m("", "big; tune; ", mappings) == {:ok, "big\ntune\n"}
      assert Buffer.m("", "; ;tumble; weed; ", mappings) == {:ok, "\n;tumble\nweed\n"}
    end

    test "expands curly-quoted scripts", %{mappings: mappings} do
      assert Buffer.m("", "zero {range 4} five", mappings) == {:ok, "zero 1\n2\n3\n4 five"}
      assert Buffer.m("", "do you {buffer foo}?", mappings) == {:ok, "do you foo?"}
      assert Buffer.m("", "yes {buffer WHEE; casel; replace whee we} can", mappings) == {:ok, "yes we can"}
    end

    test "runs curly-quoted scripts against `buffer`", %{mappings: mappings} do
      assert Buffer.m("TWO", "one {casel} three", mappings) == {:ok, "one two three"}
      assert Buffer.m("", "empty :{}: script", mappings) == {:ok, "empty :: script"}
      assert Buffer.m("foo", "empty :{buffer}: script2", mappings) == {:ok, "empty :: script2"}
      assert Buffer.m("pepsi", "{caseu; replace SI PER}, achew!", mappings) == {:ok, "PEPPER, achew!"}
    end

    test "expands multiple curly-quoted scripts", %{mappings: mappings} do
      assert Buffer.m("TREBLE", "14da {casel} 24da {replace TREBLE bass}", mappings) == {:ok, "14da treble 24da bass"}
      assert Buffer.m("HI", "{casel} {buffer low}, {buffer let's go!}", mappings) == {:ok, "hi low, let's go!"}
      assert Buffer.m("", "one; :{buffer two}:{buffer three}", mappings) == {:ok, "one\n:two:three"}
    end

    test "returns curly-quoted script errors", %{mappings: mappings} do
      assert Buffer.m("", "{error 1st} {error 2nd}", mappings) ==
        {:error, Mc.Modifier.Buffer, :script_error, "{error 1st} {error 2nd}", [{Mc.Modifier.Error, :error, "1st"}]}

      assert Buffer.m("", "{range x; m rand 7}", mappings) ==
        {:error, Mc.Modifier.Buffer, :script_error, "{range x; m rand 7}", [{Mc.Modifier.Range, :bad_limits, "x"}]}
    end

    test "works with ok-tuples", %{mappings: mappings} do
      assert Buffer.m({:ok, "LOCKDOWN"}, "full {casel}", mappings) == {:ok, "full lockdown"}
    end

    test "allows error-tuples to pass through" do
      assert Buffer.m({:error, Mod, :fuel, "low", []}, "", %{}) == {:error, Mod, :fuel, "low", []}
    end
  end
end
