defmodule McTest do
  use ExUnit.Case, async: true

  setup do
    %{mappings: %Mc.Mappings{}}
  end

  describe "modify/3" do
    test "returns a modified `buffer`", %{mappings: mappings} do
      assert Mc.modify("on the radio\n", "caseu", mappings) == {:ok, "ON THE RADIO\n"}
      assert Mc.modify("FOO BAR", "replace O @\ncasel\nappend !", mappings) == {:ok, "f@@ bar!"}
    end

    test "halts the 'chain' when the 'stop' modifier is encountered", %{mappings: mappings} do
      assert Mc.modify("CASH", "casel\nstop\nappend won't be appended", mappings) == {:ok, "cash"}
    end

    test "ignores leading whitespace in script lines", %{mappings: mappings} do
      assert Mc.modify("one\ntwo", "    countl", mappings) == {:ok, "2"}
      assert Mc.modify("ZONE", " \t casel\n      replace z t", mappings) == {:ok, "tone"}
    end

    test "returns `buffer` when `script` is whitespace or empty", %{mappings: mappings} do
      assert Mc.modify("foo", " ", mappings) == {:ok, "foo"}
      assert Mc.modify("", "\t \n", mappings) == {:ok, ""}
      assert Mc.modify("", "\t \n\n  ", mappings) == {:ok, ""}
      assert Mc.modify("\n\n", "     ", mappings) == {:ok, "\n\n"}
      assert Mc.modify("foobar", "", mappings) == {:ok, "foobar"}
      assert Mc.modify("", "", mappings) == {:ok, ""}
    end

    test "ignores blank lines in `script`", %{mappings: mappings} do
      assert Mc.modify("SOME STUFF", "\n\n\ncasel\n\nreplace some nuff", mappings) == {:ok, "nuff stuff"}
    end

    test "ignores comments in `script`", %{mappings: mappings} do
      assert Mc.modify("SOME STUFF", "casel\n# a random comment", mappings) == {:ok, "some stuff"}
      assert Mc.modify("four4", "replace four 4\n \t #another comment", mappings) == {:ok, "44"}
    end

    test "accepts an ok tuple as `buffer`", %{mappings: mappings} do
      assert Mc.modify({:ok, "BIG"}, "casel", mappings) == {:ok, "big"}
    end

    test "accepts an error tuple as `buffer`", %{mappings: mappings} do
      assert Mc.modify({:error, "buffer error"}, "n/a", mappings) == {:error, "buffer error"}
      assert Mc.modify({:error, "foobar"}, "", mappings) == {:error, "foobar"}
    end

    test "errors for the first modifier in the 'chain' that produces an error", %{mappings: mappings} do
      assert Mc.modify("", "error an error message", mappings) == {:error, "an error message"}
      assert Mc.modify("FOOBAR", "casel\nerror 1st error\nerror 2nd error", mappings) == {:error, "1st error"}
    end

    test "errors when a modifier doesn't exist", %{mappings: mappings} do
      assert Mc.modify("n/a", "nope", mappings) == {:error, "modifier not found: nope"}
      assert Mc.modify("", "foo", mappings) == {:error, "modifier not found: foo"}
    end
  end
end
