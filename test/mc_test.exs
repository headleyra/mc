defmodule McTest do
  use ExUnit.Case, async: true

  setup do
    %{mappings: Mc.Mappings.standard()}
  end

  describe "m/3" do
    test "returns a modified `buffer`", %{mappings: mappings} do
      assert Mc.m("on the radio\n", "caseu", mappings) == {:ok, "ON THE RADIO\n"}
      assert Mc.m("FOO BAR", "replace O @\ncasel\nappend !", mappings) == {:ok, "f@@ bar!"}
    end

    test "halts the 'chain' when the 'stop' modifier is encountered", %{mappings: mappings} do
      assert Mc.m("CASH", "casel\nstop\nappend won't be appended", mappings) == {:ok, "cash"}
    end

    test "ignores leading whitespace in script lines", %{mappings: mappings} do
      assert Mc.m("one\ntwo", "    countl", mappings) == {:ok, "2"}
      assert Mc.m("ZONE", " \t casel\n      replace z t", mappings) == {:ok, "tone"}
    end

    test "returns `buffer` when `script` is whitespace or empty", %{mappings: mappings} do
      assert Mc.m("foo", " ", mappings) == {:ok, "foo"}
      assert Mc.m("", "\t \n", mappings) == {:ok, ""}
      assert Mc.m("", "\t \n\n  ", mappings) == {:ok, ""}
      assert Mc.m("\n\n", "     ", mappings) == {:ok, "\n\n"}
      assert Mc.m("foobar", "", mappings) == {:ok, "foobar"}
      assert Mc.m("", "", mappings) == {:ok, ""}
    end

    test "ignores blank lines in `script`", %{mappings: mappings} do
      assert Mc.m("SOME STUFF", "\n\n\ncasel\n\nreplace some nuff", mappings) == {:ok, "nuff stuff"}
    end

    test "ignores comments in `script`", %{mappings: mappings} do
      assert Mc.m("SOME STUFF", "casel\n# a random comment", mappings) == {:ok, "some stuff"}
      assert Mc.m("four4", "replace four 4\n \t #another comment", mappings) == {:ok, "44"}
    end

    test "accepts an ok tuple as `buffer`", %{mappings: mappings} do
      assert Mc.m({:ok, "BIG"}, "casel", mappings) == {:ok, "big"}
    end

    test "accepts an error tuple as `buffer`", %{mappings: mappings} do
      assert Mc.m({:error, "buffer error"}, "n/a", mappings) == {:error, "buffer error"}
      assert Mc.m({:error, "foobar"}, "", mappings) == {:error, "foobar"}
    end

    test "errors for the first modifier in the 'chain' that produces an error", %{mappings: mappings} do
      assert Mc.m("", "error an error message", mappings) == {:error, "an error message"}
      assert Mc.m("FOOBAR", "casel\nerror 1st error\nerror 2nd error", mappings) == {:error, "1st error"}
    end

    test "errors when a modifier doesn't exist", %{mappings: mappings} do
      assert Mc.m("n/a", "nope", mappings) == {:error, "modifier not found: nope"}
      assert Mc.m("", "foo", mappings) == {:error, "modifier not found: foo"}
    end
  end

  describe "m/2" do
    test "is the equivalent of m/3 with an empty `buffer`", %{mappings: mappings} do
      assert Mc.m("append foo", mappings) == Mc.m("", "append foo", mappings)
    end
  end
end
