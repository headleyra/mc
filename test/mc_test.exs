defmodule McTest do
  use ExUnit.Case, async: true

  describe "modify/3" do
    test "returns a modified `buffer`" do
      assert Mc.modify("ON THE RADIO\n", "casel", %Mc.Mappings{}) == {:ok, "on the radio\n"}
      assert Mc.modify("hurry, offer ends SOON!", "countc", %Mc.Mappings{}) == {:ok, "23"}
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

  describe "tripleize/2" do
    test "converts a modifier 'double' into a 'triple'" do
      assert Mc.tripleize({:replace, "arg1 arg2"}, %Mc.Mappings{}) == {Mc.Modifier.Replace, :modify, "arg1 arg2"}
      assert Mc.tripleize({:casel, nil}, %Mc.Mappings{}) == {Mc.Modifier.CaseL, :modify, nil}
    end

    test "returns the error modifier 'triple' when the modifier doesn't exist in the mappings" do
      assert Mc.tripleize({:nah, "arg"}, %Mc.Mappings{}) == {Mc.Modifier.Error, :modify, "modifier not found: nah"}
    end
  end

  describe "listize/1" do
    test "converts `script` into a list of modifier 'doubles'" do
      assert Mc.listize("\nbuffer arg\n\n") == [{:buffer, "arg"}]
      assert Mc.listize("GO 1") == [{:GO, "1"}]
    end

    test "removes leading whitespace before the modifier name" do
      assert Mc.listize("  dostuff foo") == [{:dostuff, "foo"}]
      assert Mc.listize(" \t  send a b") == [{:send, "a b"}]
    end

    test "converts a script referencing several modifiers" do
      script = """
      Biz
        \t
        foo ARG
      bar Arg1 arg2
      """

      assert Mc.listize(script) == [{:Biz, ""}, {:foo, "ARG"}, {:bar, "Arg1 arg2"}]
    end

    test "ignores comments in the script" do
      script = """
        biz
      # Just saying
      Foo arg
      ##n/a
      """

      assert Mc.listize(script) == [{:biz, ""}, {:Foo, "arg"}]
    end
  end

  describe "doubleize/1" do
    test "creates a modifier 'double' given a 'modify instruction'" do
      assert Mc.doubleize("modifier_name arg1") == {:modifier_name, "arg1"}
      assert Mc.doubleize("myModName_ Team") == {:myModName_, "Team"}
      assert Mc.doubleize("eMiX 10") == {:eMiX, "10"}
      assert Mc.doubleize("biz") == {:biz, ""}
      assert Mc.doubleize("BosH") == {:BosH, ""}
      assert Mc.doubleize("modifier_name arg1 arg2") == {:modifier_name, "arg1 arg2"}
    end

    test "assumes the modifier name and args are separated by *exactly* one space" do
      assert Mc.doubleize("Bosh \s\t   arg1") == {:Bosh, "\s\t   arg1"}
      assert Mc.doubleize("fix arg1 ... \t .*_ arg2\s") == {:fix, "arg1 ... \t .*_ arg2\s"}
    end
  end
end
