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

    test "expands back-quoted scripts", %{mappings: mappings} do
      assert Buffer.m("", "zero {range 4} five", mappings) == {:ok, "zero 1\n2\n3\n4 five"}
      assert Buffer.m("", "do you {buffer foo}?", mappings) == {:ok, "do you foo?"}

      assert Buffer.m("", "yes {buffer WHEE; casel; replace whee we} can", mappings) ==
        {:ok, "yes we can"}
    end

    test "runs back-quoted scripts against `buffer`", %{mappings: mappings} do
      assert Buffer.m("TWO", "one {casel} three", mappings) == {:ok, "one two three"}
      assert Buffer.m("", "empty :{}: script", mappings) == {:ok, "empty :: script"}
      assert Buffer.m("foo", "empty :{buffer}: script2", mappings) == {:ok, "empty :: script2"}
      assert Buffer.m("stuff", "{caseu; replace T N}, achew!", mappings) == {:ok, "SNUFF, achew!"}
    end

    test "expands multiple back-quoted scripts", %{mappings: mappings} do
      assert Buffer.m("TREBLE", "14da {casel} 24da {replace TREBLE bass}", mappings) ==
        {:ok, "14da treble 24da bass"}

      assert Buffer.m("HI", "{casel} {buffer low}, {buffer let's go!}", mappings) ==
        {:ok, "hi low, let's go!"}

      assert Buffer.m("", "one; :{buffer two}:{buffer three}", mappings) ==
        {:ok, "one\n:two:three"}
    end

    test "returns back-quoted script errors", %{mappings: mappings} do
      assert Buffer.m("", "{error oops}", mappings) == {:error, "oops"}
      assert Buffer.m("", "{error first} {error second}", mappings) == {:error, "first"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert Buffer.m({:ok, "LOCKDOWN"}, "full {casel}", mappings) == {:ok, "full lockdown"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert Buffer.m({:error, "reason"}, "", mappings) == {:error, "reason"}
    end
  end
end
