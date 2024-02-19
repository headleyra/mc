defmodule McTest do
  use ExUnit.Case, async: true

  describe "modify/3" do
    test "returns a modified `buffer`" do
      assert Mc.modify("on the radio\n", "caseu", %Mc.Mappings{}) == {:ok, "ON THE RADIO\n"}
      assert Mc.modify("FOO BAR", "replace O @\ncasel\nappend !", %Mc.Mappings{}) == {:ok, "f@@ bar!"}
    end

    test "halts the 'chain' when the 'stop' modifier is encountered" do
      assert Mc.modify("CASH", "casel\nstop\nappend won't be appended", %Mc.Mappings{}) == {:ok, "cash"}
    end

    test "ignores leading whitespace in script lines" do
      assert Mc.modify("one\ntwo", "    countl", %Mc.Mappings{}) == {:ok, "2"}
      assert Mc.modify("ZONE", " \t casel\n      replace z t", %Mc.Mappings{}) == {:ok, "tone"}
    end

    test "returns `buffer` when `script` is whitespace or empty" do
      assert Mc.modify("foo", " ", %Mc.Mappings{}) == {:ok, "foo"}
      assert Mc.modify("", "\t \n", %Mc.Mappings{}) == {:ok, ""}
      assert Mc.modify("", "\t \n\n  ", %Mc.Mappings{}) == {:ok, ""}
      assert Mc.modify("\n\n", "     ", %Mc.Mappings{}) == {:ok, "\n\n"}
      assert Mc.modify("foobar", "", %Mc.Mappings{}) == {:ok, "foobar"}
      assert Mc.modify("", "", %Mc.Mappings{}) == {:ok, ""}
    end

    test "ignores blank lines in `script`" do
      assert Mc.modify("SOME STUFF", "\n\n\ncasel\n\nreplace some nuff", %Mc.Mappings{}) == {:ok, "nuff stuff"}
    end

    test "ignores comments in `script`" do
      assert Mc.modify("SOME STUFF", "casel\n# a random comment", %Mc.Mappings{}) == {:ok, "some stuff"}
      assert Mc.modify("four4", "replace four 4\n \t #another comment", %Mc.Mappings{}) == {:ok, "44"}
    end

    test "accepts an ok tuple as `buffer`" do
      assert Mc.modify({:ok, "BIG"}, "casel", %Mc.Mappings{}) == {:ok, "big"}
    end

    test "accepts an error tuple as `buffer`" do
      assert Mc.modify({:error, "buffer error"}, "n/a", %Mc.Mappings{}) == {:error, "buffer error"}
      assert Mc.modify({:error, "foobar"}, "", %Mc.Mappings{}) == {:error, "foobar"}
    end

    test "errors for the first modifier in the 'chain' that produces an error" do
      assert Mc.modify("", "error an error message", %Mc.Mappings{}) == {:error, "an error message"}
      assert Mc.modify("FOOBAR", "casel\nerror 1st error\nerror 2nd error", %Mc.Mappings{}) == {:error, "1st error"}
    end

    test "errors when a modifier doesn't exist" do
      assert Mc.modify("n/a", "nope", %Mc.Mappings{}) == {:error, "modifier not found: nope"}
      assert Mc.modify("", "foo", %Mc.Mappings{}) == {:error, "modifier not found: foo"}
    end
  end
end
