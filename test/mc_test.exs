defmodule McTest do
  use ExUnit.Case, async: true

  describe "Mc.modify/2" do
    test "returns a modified `buffer`" do
      assert Mc.modify("ON THE RADIO\n", "lcase") == {:ok, "on the radio\n"}
      assert Mc.modify("hurry, offer ends SOON!", "ccount") == {:ok, "23"}
    end

    test "returns `buffer` when `script` is whitespace" do
      assert Mc.modify("foo", " ") == {:ok, "foo"}
      assert Mc.modify("", "\t \n") == {:ok, ""}
      assert Mc.modify("", "\t \n\n  ") == {:ok, ""}
      assert Mc.modify("\n\n", "     ") == {:ok, "\n\n"}
    end

    test "returns `buffer` when `script` is an empty string" do
      assert Mc.modify("foobar", "") == {:ok, "foobar"}
      assert Mc.modify("", "") == {:ok, ""}
    end

    test "errors for the first modifier in the 'chain' that produces an error" do
      assert Mc.modify("n/a", "error an error message") == {:error, "an error message"}
      assert Mc.modify("FOOBAR", "lcase\nerror 1st error\nerror 2nd error") == {:error, "1st error"}
    end

    test "ignores blank lines in the script" do
      assert Mc.modify("SOME STUFF", "\n\n\nlcase\n\nreplace some nuff") == {:ok, "nuff stuff"}
    end

    test "ignores comments in the script" do
      assert Mc.modify("SOME STUFF", "lcase\n# no.exist.modifier") == {:ok, "some stuff"}
    end
  end

  describe "Mc.tripleize/2" do
    test "converts a 'modifier tuple' into a 'triple'" do
      assert Mc.tripleize({:buffer, "arg1 arg2"}, %Mc.Mappings{}) == {Mc.Modifier.Buffer, :modify, "arg1 arg2"}
      assert Mc.tripleize({:lcase, nil}, %Mc.Mappings{}) == {Mc.Modifier.Lcase, :modify, nil}
    end

    test "returns the error modifier 'triple' when the modifier doesn't exist in the mappings" do
      assert Mc.tripleize({:doesnt_exist, "arg"}, %Mc.Mappings{}) == {Mc.Modifier.Error, :modify, "not found: doesnt_exist"}
    end
  end

  describe "Mc.listize/1" do
    test "converts a script into a list of 'modifier tuples'" do
      assert Mc.listize("\nbuffer arg\n\n") == [{:buffer, "arg"}]
      assert Mc.listize("GO 1") == [{:GO, "1"}]
    end

    test "removes leading white space before the modifier name" do
      assert Mc.listize("  dostuff foo") == [{:dostuff, "foo"}]
      assert Mc.listize(" \t  send a b") == [{:send, "a b"}]
    end

    test "converts a script referencing several modifiers" do
      script = """
      Biz
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

  describe "Mc.tupleize/1" do
    test "creates a 'modifier tuple' given a 'modify instruction'" do
      assert Mc.tupleize("modifier_name arg1") == {:modifier_name, "arg1"}
      assert Mc.tupleize("myModName_ Team") == {:myModName_, "Team"}
      assert Mc.tupleize("eMiX 10") == {:eMiX, "10"}
      assert Mc.tupleize("biz") == {:biz, ""}
      assert Mc.tupleize("BosH") == {:BosH, ""}
      assert Mc.tupleize("a_mode_name arg1 arg2") == {:a_mode_name, "arg1 arg2"}
    end

    test "assumes the modifier name and args are separated by exactly one space" do
      assert Mc.tupleize("Bosh \s\t   arg1") == {:Bosh, "\s\t   arg1"}
      assert Mc.tupleize("fix arg1 ... \t .*_ arg2\s") == {:fix, "arg1 ... \t .*_ arg2\s"}
    end
  end

  describe "Mc.is_comment?/1" do
    test "returns true if `string` is a comment" do
      assert Mc.is_comment?("# this is a comment")
      assert Mc.is_comment?(" \t # so is this")
      assert Mc.is_comment?("#")
      assert Mc.is_comment?("# foobar #")
      assert Mc.is_comment?("\t# and this")
    end

    test "returns false if `string` isn't a comment" do
      refute Mc.is_comment?("this #is not a comment")
      refute Mc.is_comment?("no#r this")
    end
  end
end
