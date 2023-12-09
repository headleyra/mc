defmodule Mc.Modifier.BufferTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Buffer

  defmodule Mappings do
    defstruct [
      buffer: {Mc.Modifier.Buffer, :modify},
      error: {Mc.Modifier.Error, :modify},
      lcase: {Mc.Modifier.Lcase, :modify},
      replace: {Mc.Modifier.Replace, :modify},
      range: {Mc.Modifier.Range, :modify},
      ucase: {Mc.Modifier.Ucase, :modify}
    ]
  end

  describe "modify/3" do
    test "returns `args`" do
      assert Buffer.modify("n/a", "these are some args", %Mappings{}) == {:ok, "these are some args"}
      assert Buffer.modify("", "NWO\nIMF\nWHO\nWTO", %Mappings{}) == {:ok, "NWO\nIMF\nWHO\nWTO"}
      assert Buffer.modify("foo", "", %Mappings{}) == {:ok, ""}
    end

    test "parses `args` as an 'inline string'" do
      assert Buffer.modify("", "will split into; lines", %Mappings{}) == {:ok, "will split into\nlines"}
      assert Buffer.modify("", "will not split into;lines", %Mappings{}) == {:ok, "will not split into;lines"}
      assert Buffer.modify("", "foo;bar;", %Mappings{}) == {:ok, "foo;bar;"}
      assert Buffer.modify("", "big; tune; ", %Mappings{}) == {:ok, "big\ntune\n"}
      assert Buffer.modify("", "foo %%20bar", %Mappings{}) == {:ok, "foo % bar"}
      assert Buffer.modify("", "; ;tumble; weed; ", %Mappings{}) == {:ok, "\n;tumble\nweed\n"}
    end

    test "expands 'back-ticked' scripts" do
      assert Buffer.modify("", "zero `range 4` five", %Mappings{}) == {:ok, "zero 1\n2\n3\n4 five"}
      assert Buffer.modify("", "do you `buffer foo`?", %Mappings{}) == {:ok, "do you foo?"}
      assert Buffer.modify("", "yes `buffer WHEE; lcase; replace whee we` can", %Mappings{}) == {:ok, "yes we can"}
    end

    test "runs back-ticked scripts against `buffer`" do
      assert Buffer.modify("TWO", "one `lcase` three", %Mappings{}) == {:ok, "one two three"}
      assert Buffer.modify("", "empty :``: script", %Mappings{}) == {:ok, "empty :: script"}
      assert Buffer.modify("foo", "empty :`buffer`: script2", %Mappings{}) == {:ok, "empty :: script2"}
      assert Buffer.modify("stuff", "`ucase; replace T N`, achew!", %Mappings{}) == {:ok, "SNUFF, achew!"}
    end

    test "expands multiple back-ticked scripts" do
      assert Buffer.modify("TREBLE", "14da `lcase` 24da `replace TREBLE bass`", %Mappings{}) ==
        {:ok, "14da treble 24da bass"}

      assert Buffer.modify("HI", "`lcase` `buffer low`, `buffer let us%250ago!`", %Mappings{}) ==
        {:ok, "hi low, let us\ngo!"}

      assert Buffer.modify("", "one%0a :`buffer two`:`buffer three`: %09four", %Mappings{}) ==
        {:ok, "one\n :two:three: \tfour"}
    end

    test "returns back-ticked script errors" do
      assert Buffer.modify("", "`error oops`", %Mappings{}) == {:error, "oops"}
      assert Buffer.modify("", "`error first` `error second`", %Mappings{}) == {:error, "first"}
    end

    test "works with ok tuples" do
      assert Buffer.modify({:ok, "LOCKDOWN"}, "full `lcase`", %Mappings{}) == {:ok, "full lockdown"}
    end

    test "allows error tuples to pass through" do
      assert Buffer.modify({:error, "reason"}, "", %Mappings{}) == {:error, "reason"}
    end
  end
end
