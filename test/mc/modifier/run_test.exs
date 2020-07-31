defmodule Mc.Modifier.RunTest do
  use ExUnit.Case, async: false
  alias Mc.Modifier.Run
  alias Mc.Modifier.Kv

  setup do
    start_supervised({Mc, %Mc.Mappings{}})
    start_supervised({Kv, %{
      "script1" => "replace FOO RADIO\nlcase",
      "s2" => "lcase\nr bass treble\nr one two",
      "s3" => ""
    }})
    :ok
  end

  describe "Mc.Modifier.Run.modify/2" do
    test "treats `buffer` as a script and 'runs' it" do
      assert Run.modify("buffer FOO\nlcase", "") == {:ok, "foo"}
      assert Run.modify("buffer BAR\nlcase", "n/a") == {:ok, "bar"}
    end

    test "accepts ok tuples" do
      assert Run.modify({:ok, "buffer look\nreplace l b"}, "") == {:ok, "book"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Run.modify({:error, "reason"}, "gets ignored") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Run.modifyk/2" do
    test "'runs' the script referenced by key (i.e., `args`) on the `buffer`" do
      assert Run.modifyk("stay in FOO contact", "script1") == {:ok, "stay in radio contact"}
      assert Run.modifyk("one 4 da BASS", "s2") == {:ok, "two 4 da treble"}
      assert Run.modifyk("one 4 da BASS", "s3") == {:ok, "one 4 da BASS"}
    end

    test "returns `buffer` intact, when key references a script that doesn't exist" do
      assert Run.modifyk("still the same", "nope") == {:ok, "still the same"}
      assert Run.modifyk("no change", "") == {:ok, "no change"}
    end

    test "accepts ok tuples" do
      assert Run.modifyk({:ok, "FOO"}, "script1") == {:ok, "radio"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Run.modifyk({:error, "reason"}, "gets ignored") == {:error, "reason"}
    end
  end
end
