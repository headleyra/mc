defmodule Mc.Modifier.BufferTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Buffer

  setup do
    start_supervised({Mc.Modifier.Kv, %{}})
    start_supervised({Mc, %Mc.Mappings{}})
    :ok
  end

  describe "Mc.Modifier.Buffer.modify/2" do
    test "returns `args`" do
      assert Buffer.modify("n/a", "these are some args") == {:ok, "these are some args"}
      assert Buffer.modify("", "NWO\nIMF\nWHO\nWTO") == {:ok, "NWO\nIMF\nWHO\nWTO"}
    end

    test "works with the 'inline args' format" do
      assert Buffer.modify("n/a", "split into; lines") == {:ok, "split into\nlines"}
      assert Buffer.modify("", "won't split into;lines") == {:ok, "won't split into;lines"}
      assert Buffer.modify("", "foo;bar;") == {:ok, "foo;bar;"}
      assert Buffer.modify("", "big; tune; ") == {:ok, "big\ntune\n"}
    end

    test "returns `args` with 'inline scripts' replaced (scripts are delimted with '`' and '`')" do
      assert Buffer.modify("n/a", "one `range 2 3` four") == {:ok, "one 2\n3 four"}
      assert Buffer.modify("", "do you `buffer foo`?") == {:ok, "do you foo?"}
      assert Buffer.modify("", "yes `buffer WHEE; lcase; replace whee we` can") == {:ok, "yes we can"}
      assert Buffer.modify("", "== `buffer FOO %0a lcase; replace foo bar` ==") == {:ok, "== bar  =="}
      assert Buffer.modify("stuff", "`ucase; replace T N`, achew!") == {:ok, "SNUFF, achew!"}
      assert Buffer.modify("", "; ;tumble; weed; ") == {:ok, "\n;tumble\nweed\n"}
    end

    test "'runs' 'inline scripts' against the `buffer`" do
      assert Buffer.modify("TWO", "one `lcase` three") == {:ok, "one two three"}
      assert Buffer.modify("", "empty :``: script") == {:ok, "empty :: script"}
      assert Buffer.modify("foo", "empty :`buffer`: script2") == {:ok, "empty :: script2"}
    end

    test "works with the 'inline args' format outside of replacements" do
      assert Buffer.modify("", "one%0a :`b two`:`b three`: %09four") == {:ok, "one\n :two:three: \tfour"}
    end

    test "retruns `args` unchanged if there are no replacements" do
      assert Buffer.modify("bosh", "nowt going on") == {:ok, "nowt going on"}
      assert Buffer.modify("", "work from home") == {:ok, "work from home"}
    end

    test "handles multiple replacements" do
      assert Buffer.modify("TREBLE", "14da `lcase` 24da `r TREBLE bass`") == {:ok, "14da treble 24da bass"}
      # hint: URI.encode("%") => "%25"
      assert Buffer.modify("HI", "`lcase` `b low`, `b let's%250ago!`") == {:ok, "hi low, let's\ngo!"}
    end

    test "handles replacements that return error tuples" do
      assert Buffer.modify("", "`error oops`") == {:error, "oops"}
      assert Buffer.modify("", "`error first` `error second`") == {:error, "first"}
    end

    test "returns an error tuple for badly formed URI characters" do
      assert Buffer.modify("n/a", "foo %%20 bar") == {:error, "Buffer: bad URI"}
      assert Buffer.modify("FOO", "`replace FOO %%`") == {:error, "Buffer: bad URI"}
    end

    test "works with ok tuples" do
      assert Buffer.modify({:ok, "LOCKDOWN"}, "full `lcase`") == {:ok, "full lockdown"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Buffer.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
