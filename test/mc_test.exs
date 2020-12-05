defmodule McTest do
  use ExUnit.Case, async: false

  defmodule TestModifier do
    def test_func(buffer, args), do: {:ok, "#{buffer} *#{args}*"}
  end

  setup do
    mappings = %Mc.Mappings{} |> Map.merge(%{tweak: {TestModifier, :test_func}})
    start_supervised({Mc, mappings: mappings})
    :ok
  end

  describe "Mc.modify/2" do
    test "returns a modified `buffer`" do
      assert Mc.modify("ON THE RADIO\n", "lcase") == {:ok, "on the radio\n"}
      assert Mc.modify("hurry, offer ends SOON!", "ccount") == {:ok, "23"}
    end

    test "returns a modified `buffer` (custom modifier)" do
      assert Mc.modify("let's", "tweak go") == {:ok, "let's *go*"}
    end

    test "returns `buffer` when `script` is *all* whitespace" do
      assert Mc.modify("foo", " ") == {:ok, "foo"}
      assert Mc.modify("", "\t \n") == {:ok, ""}
      assert Mc.modify("", "\t \n\n  ") == {:ok, ""}
      assert Mc.modify("\n\n", "     ") == {:ok, "\n\n"}
    end

    test "returns `buffer` when `script` is an empty string" do
      assert Mc.modify("foobar", "") == {:ok, "foobar"}
      assert Mc.modify("", "") == {:ok, ""}
    end

    test "returns an error tuple for the first modifier in the 'chain' that produces an error" do
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

  describe "Mc.double_to_triple/2" do
    test "converts a modifier 'double' into a 'triple'" do
      assert Mc.double_to_triple({:buffer, "arg1 arg2"}, %Mc.Mappings{}) == {Mc.Modifier.Buffer, :modify, "arg1 arg2"}
      assert Mc.double_to_triple({:lcase, nil}, %Mc.Mappings{}) == {Mc.Modifier.Lcase, :modify, nil}
    end

    test "returns the error modifier 'triple' when the modifier doesn't exist in the mappings" do
      assert Mc.double_to_triple({:doesnt_exist, "arg"}, %Mc.Mappings{}) == {Mc.Modifier.Error, :modify, "Not found: doesnt_exist"}
    end
  end

  describe "Mc.script_to_double_list/1" do
    test "converts a single-line script to internal form" do
      assert Mc.script_to_double_list("\nbuffer arg\n\n") == [{:buffer, "arg"}]
      assert Mc.script_to_double_list("GO 1") == [{:GO, "1"}]
    end

    test "removes leading white space before the modifier name" do
      assert Mc.script_to_double_list("  dostuff foo") == [{:dostuff, "foo"}]
      assert Mc.script_to_double_list(" \t  send a b") == [{:send, "a b"}]
    end

    test "converts a single-line script (with a comment)" do
      script = """
      # This should be ignored ...
      rAndom arg1 arg2
      """
      assert Mc.script_to_double_list(script) == [{:rAndom, "arg1 arg2"}]
    end

    test "converts a multi-line script" do
      script = """
      Biz
        foo ARG
      bar Arg1 arg2
      """
      assert Mc.script_to_double_list(script) == [{:Biz, ""}, {:foo, "ARG"}, {:bar, "Arg1 arg2"}]
    end

    test "converts a multi-line script (with a comment)" do
      script = """
        biz
      # Just saying
      Foo arg
      ##n/a
      """
      assert Mc.script_to_double_list(script) == [{:biz, ""}, {:Foo, "arg"}]
    end
  end

  describe "Mc.modify_instruction_to_double/1" do
    test "splits a 'modify instruction' into a modifier-name-atom/arguments tuple" do
      assert Mc.modify_instruction_to_double("modifier_name arg1") == {:modifier_name, "arg1"}
      assert Mc.modify_instruction_to_double("myModName_ Team") == {:myModName_, "Team"}
      assert Mc.modify_instruction_to_double("eMiX 10") == {:eMiX, "10"}
      assert Mc.modify_instruction_to_double("biz") == {:biz, ""}
      assert Mc.modify_instruction_to_double("BosH") == {:BosH, ""}
      assert Mc.modify_instruction_to_double("a_mode_name arg1 arg2") == {:a_mode_name, "arg1 arg2"}
    end

    test "assumes the modifier name and args are separated by exactly one space" do
      assert Mc.modify_instruction_to_double("Bosh \s\t   arg1") == {:Bosh, "\s\t   arg1"}
      assert Mc.modify_instruction_to_double("fix arg1 ... \t .*_ arg2\s") == {:fix, "arg1 ... \t .*_ arg2\s"}
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
