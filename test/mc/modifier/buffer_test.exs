defmodule Mc.Modifier.BufferTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Buffer

  describe "modify/3" do
    test "returns `args`" do
      assert Buffer.modify("n/a", "these are some args", %Mc.Mappings{}) == {:ok, "these are some args"}
      assert Buffer.modify("", "NWO\nIMF\nWHO\nWTO", %Mc.Mappings{}) == {:ok, "NWO\nIMF\nWHO\nWTO"}
      assert Buffer.modify("foo", "", %Mc.Mappings{}) == {:ok, ""}
    end

    test "parses `args` as an 'inline string'" do
      assert Buffer.modify("", "will split into; lines", %Mc.Mappings{}) == {:ok, "will split into\nlines"}
      assert Buffer.modify("", "will not split into;lines", %Mc.Mappings{}) == {:ok, "will not split into;lines"}
      assert Buffer.modify("", "foo;bar;", %Mc.Mappings{}) == {:ok, "foo;bar;"}
      assert Buffer.modify("", "big; tune; ", %Mc.Mappings{}) == {:ok, "big\ntune\n"}
      assert Buffer.modify("", "foo %%20bar", %Mc.Mappings{}) == {:ok, "foo % bar"}
      assert Buffer.modify("", "; ;tumble; weed; ", %Mc.Mappings{}) == {:ok, "\n;tumble\nweed\n"}
    end

    test "expands 'back-ticked' scripts" do
      assert Buffer.modify("", "zero `range 4` five", %Mc.Mappings{}) == {:ok, "zero 1\n2\n3\n4 five"}
      assert Buffer.modify("", "do you `buffer foo`?", %Mc.Mappings{}) == {:ok, "do you foo?"}
      assert Buffer.modify("", "yes `buffer WHEE; casel; replace whee we` can", %Mc.Mappings{}) == {:ok, "yes we can"}
    end

    test "runs back-ticked scripts against `buffer`" do
      assert Buffer.modify("TWO", "one `casel` three", %Mc.Mappings{}) == {:ok, "one two three"}
      assert Buffer.modify("", "empty :``: script", %Mc.Mappings{}) == {:ok, "empty :: script"}
      assert Buffer.modify("foo", "empty :`buffer`: script2", %Mc.Mappings{}) == {:ok, "empty :: script2"}
      assert Buffer.modify("stuff", "`caseu; replace T N`, achew!", %Mc.Mappings{}) == {:ok, "SNUFF, achew!"}
    end

    test "expands multiple back-ticked scripts" do
      assert Buffer.modify("TREBLE", "14da `casel` 24da `replace TREBLE bass`", %Mc.Mappings{}) ==
        {:ok, "14da treble 24da bass"}

      assert Buffer.modify("HI", "`casel` `buffer low`, `buffer let us%250ago!`", %Mc.Mappings{}) ==
        {:ok, "hi low, let us\ngo!"}

      assert Buffer.modify("", "one%0a :`buffer two`:`buffer three`: %09four", %Mc.Mappings{}) ==
        {:ok, "one\n :two:three: \tfour"}
    end

    test "returns back-ticked script errors" do
      assert Buffer.modify("", "`error oops`", %Mc.Mappings{}) == {:error, "oops"}
      assert Buffer.modify("", "`error first` `error second`", %Mc.Mappings{}) == {:error, "first"}
    end

    test "works with ok tuples" do
      assert Buffer.modify({:ok, "LOCKDOWN"}, "full `casel`", %Mc.Mappings{}) == {:ok, "full lockdown"}
    end

    test "allows error tuples to pass through" do
      assert Buffer.modify({:error, "reason"}, "", %Mc.Mappings{}) == {:error, "reason"}
    end
  end
end
