defmodule Mc.Modifier.BufferTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Buffer

  setup do
    start_supervised({Mc, mappings: %Mc.Mappings{}})
    :ok
  end

  describe "modify/2" do
    test "returns `args`" do
      assert Buffer.modify("n/a", "these are some args") == {:ok, "these are some args"}
      assert Buffer.modify("", "NWO\nIMF\nWHO\nWTO") == {:ok, "NWO\nIMF\nWHO\nWTO"}
      assert Buffer.modify("foo", "") == {:ok, ""}
    end

    test "parses `args` as an 'inline string'" do
      assert Buffer.modify("", "will split into; lines") == {:ok, "will split into\nlines"}
      assert Buffer.modify("", "will not split into;lines") == {:ok, "will not split into;lines"}
      assert Buffer.modify("", "foo;bar;") == {:ok, "foo;bar;"}
      assert Buffer.modify("", "big; tune; ") == {:ok, "big\ntune\n"}
      assert Buffer.modify("", "foo %%20bar") == {:ok, "foo % bar"}
    end

    test "expands 'back-ticked' scripts" do
      assert Buffer.modify("", "zero `range 4` five") == {:ok, "zero 1\n2\n3\n4 five"}
      assert Buffer.modify("", "do you `buffer foo`?") == {:ok, "do you foo?"}
      assert Buffer.modify("", "yes `buffer WHEE; lcase; replace whee we` can") == {:ok, "yes we can"}
      assert Buffer.modify("", "; ;tumble; weed; ") == {:ok, "\n;tumble\nweed\n"}
    end

    test "runs back-ticked scripts against `buffer`" do
      assert Buffer.modify("TWO", "one `lcase` three") == {:ok, "one two three"}
      assert Buffer.modify("", "empty :``: script") == {:ok, "empty :: script"}
      assert Buffer.modify("foo", "empty :`buffer`: script2") == {:ok, "empty :: script2"}
      assert Buffer.modify("stuff", "`ucase; replace T N`, achew!") == {:ok, "SNUFF, achew!"}
    end

    test "expands multiple back-ticked scripts" do
      assert Buffer.modify("TREBLE", "14da `lcase` 24da `r TREBLE bass`") == {:ok, "14da treble 24da bass"}
      assert Buffer.modify("HI", "`lcase` `b low`, `b let us%250ago!`") == {:ok, "hi low, let us\ngo!"}
      assert Buffer.modify("", "one%0a :`b two`:`b three`: %09four") == {:ok, "one\n :two:three: \tfour"}
    end

    test "returns back-ticked script errors" do
      assert Buffer.modify("", "`error oops`") == {:error, "oops"}
      assert Buffer.modify("", "`error first` `error second`") == {:error, "first"}
    end

    test "works with ok tuples" do
      assert Buffer.modify({:ok, "LOCKDOWN"}, "full `lcase`") == {:ok, "full lockdown"}
    end

    test "allows error tuples to pass through" do
      assert Buffer.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
