defmodule Mc.Modifier.BufferTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Buffer

  setup do
    %{mappings: Mc.Mappings.s()}
  end

  describe "modify/3" do
    test "returns `args`", %{mappings: mappings} do
      assert Buffer.modify("n/a", "these are some args", mappings) == {:ok, "these are some args"}
      assert Buffer.modify("", "NWO\nIMF\nWHO\nWTO", mappings) == {:ok, "NWO\nIMF\nWHO\nWTO"}
      assert Buffer.modify("foo", "", mappings) == {:ok, ""}
      assert Buffer.modify("", "will not split into;lines", mappings) == {:ok, "will not split into;lines"}
      assert Buffer.modify("", "foo;bar;", mappings) == {:ok, "foo;bar;"}
    end

    test "parses `args` as an 'inline string'", %{mappings: mappings} do
      assert Buffer.modify("", "will split into; lines", mappings) == {:ok, "will split into\nlines"}
      assert Buffer.modify("", "big; tune; ", mappings) == {:ok, "big\ntune\n"}
      assert Buffer.modify("", "; ;tumble; weed; ", mappings) == {:ok, "\n;tumble\nweed\n"}
    end

    test "expands back-quoted scripts", %{mappings: mappings} do
      assert Buffer.modify("", "zero {range 4} five", mappings) == {:ok, "zero 1\n2\n3\n4 five"}
      assert Buffer.modify("", "do you {buffer foo}?", mappings) == {:ok, "do you foo?"}

      assert Buffer.modify("", "yes {buffer WHEE; casel; replace whee we} can", mappings) ==
        {:ok, "yes we can"}
    end

    test "runs back-quoted scripts against `buffer`", %{mappings: mappings} do
      assert Buffer.modify("TWO", "one {casel} three", mappings) == {:ok, "one two three"}
      assert Buffer.modify("", "empty :{}: script", mappings) == {:ok, "empty :: script"}
      assert Buffer.modify("foo", "empty :{buffer}: script2", mappings) == {:ok, "empty :: script2"}
      assert Buffer.modify("stuff", "{caseu; replace T N}, achew!", mappings) == {:ok, "SNUFF, achew!"}
    end

    test "expands multiple back-quoted scripts", %{mappings: mappings} do
      assert Buffer.modify("TREBLE", "14da {casel} 24da {replace TREBLE bass}", mappings) ==
        {:ok, "14da treble 24da bass"}

      assert Buffer.modify("HI", "{casel} {buffer low}, {buffer let's go!}", mappings) ==
        {:ok, "hi low, let's go!"}

      assert Buffer.modify("", "one; :{buffer two}:{buffer three}", mappings) ==
        {:ok, "one\n:two:three"}
    end

    test "returns back-quoted script errors", %{mappings: mappings} do
      assert Buffer.modify("", "{error oops}", mappings) == {:error, "oops"}
      assert Buffer.modify("", "{error first} {error second}", mappings) == {:error, "first"}
    end

    test "works with ok tuples", %{mappings: mappings} do
      assert Buffer.modify({:ok, "LOCKDOWN"}, "full {casel}", mappings) == {:ok, "full lockdown"}
    end

    test "allows error tuples to pass through", %{mappings: mappings} do
      assert Buffer.modify({:error, "reason"}, "", mappings) == {:error, "reason"}
    end
  end
end
