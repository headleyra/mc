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
      assert Mc.m({:error, Mod, :foo, "bar", []}, "", mappings) == {:error, Mod, :foo, "bar", []}
    end

    test "ignores blank lines in `script`", %{mappings: mappings} do
      assert Mc.m("SOME STUFF", "\n\n\ncasel\n\nreplace some nuff", mappings) == {:ok, "nuff stuff"}
    end

    test "ignores comments in `script`", %{mappings: mappings} do
      assert Mc.m("SOME STUFF", "casel\n# a random comment", mappings) == {:ok, "some stuff"}
      assert Mc.m("four4", "replace four 4\n \t #another comment", mappings) == {:ok, "44"}
    end

    test "halts the 'chain' when the 'stop' modifier is encountered", %{mappings: mappings} do
      assert Mc.m("CASH", "casel\nstop\nappend won't be appended", mappings) == {:ok, "cash"}
    end

    test "works with ok-tuples", %{mappings: mappings} do
      assert Mc.m({:ok, "BIG"}, "casel", mappings) == {:ok, "big"}
    end

    test "returns the error of the first modifier to generate one", %{mappings: mappings} do
      assert Mc.m("n/a", "error boom", mappings) == {:error, Mc.Modifier.Error, :error, "boom", []}
      assert Mc.m("", "error 1st\nerror 2nd", mappings) == {:error, Mc.Modifier.Error, :error, "1st", []}
    end

    test "errors when a modifier doesn't exist", %{mappings: mappings} do
      assert Mc.m("n/a", "nope", mappings) == {:error, Mc.Modifier.Unknown, :modifier_unknown, "nope", []}
      assert Mc.m("", "foo", mappings) == {:error, Mc.Modifier.Unknown, :modifier_unknown, "foo", []}
    end
  end

  describe "m/2" do
    test "delegates to m/3 with an empty `buffer`", %{mappings: mappings} do
      assert Mc.m("append foo", mappings) == Mc.m("", "append foo", mappings)
    end
  end
end
