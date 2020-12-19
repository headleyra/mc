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
    test "converts a modifier 'double' into a 'triple'" do
      assert Mc.tripleize({:buffer, "arg1 arg2"}, %Mc.Mappings{}) == {Mc.Modifier.Buffer, :modify, "arg1 arg2"}
      assert Mc.tripleize({:lcase, nil}, %Mc.Mappings{}) == {Mc.Modifier.Lcase, :modify, nil}
    end

    test "returns the error modifier 'triple' when the modifier doesn't exist in the mappings" do
      assert Mc.tripleize({:doesnt_exist, "arg"}, %Mc.Mappings{}) == {Mc.Modifier.Error, :modify, "not found: doesnt_exist"}
    end
  end

  describe "Mc.doubleize/1" do
    test "converts a single-line script to internal form" do
      assert Mc.doubleize("\nbuffer arg\n\n") == [{:buffer, "arg"}]
      assert Mc.doubleize("GO 1") == [{:GO, "1"}]
    end

    test "removes leading white space before the modifier name" do
      assert Mc.doubleize("  dostuff foo") == [{:dostuff, "foo"}]
      assert Mc.doubleize(" \t  send a b") == [{:send, "a b"}]
    end

    test "converts a single-line script (with a comment)" do
      script = """
      # This should be ignored ...
      rAndom arg1 arg2
      """
      assert Mc.doubleize(script) == [{:rAndom, "arg1 arg2"}]
    end

    test "converts a multi-line script" do
      script = """
      Biz
        foo ARG
      bar Arg1 arg2
      """
      assert Mc.doubleize(script) == [{:Biz, ""}, {:foo, "ARG"}, {:bar, "Arg1 arg2"}]
    end

    test "converts a multi-line script (with a comment)" do
      script = """
        biz
      # Just saying
      Foo arg
      ##n/a
      """
      assert Mc.doubleize(script) == [{:biz, ""}, {:Foo, "arg"}]
    end
  end

  describe "Mc.to_double/1" do
    test "splits a 'modify instruction' into a modifier-name-atom/arguments tuple" do
      assert Mc.to_double("modifier_name arg1") == {:modifier_name, "arg1"}
      assert Mc.to_double("myModName_ Team") == {:myModName_, "Team"}
      assert Mc.to_double("eMiX 10") == {:eMiX, "10"}
      assert Mc.to_double("biz") == {:biz, ""}
      assert Mc.to_double("BosH") == {:BosH, ""}
      assert Mc.to_double("a_mode_name arg1 arg2") == {:a_mode_name, "arg1 arg2"}
    end

    test "assumes the modifier name and args are separated by exactly one space" do
      assert Mc.to_double("Bosh \s\t   arg1") == {:Bosh, "\s\t   arg1"}
      assert Mc.to_double("fix arg1 ... \t .*_ arg2\s") == {:fix, "arg1 ... \t .*_ arg2\s"}
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

  describe "Mc.lookup/2" do
    test "looks up the name of the given module/function-atom pair in the mappings" do
      assert Mc.lookup(Mc.Modifier.Lcase, :modify) == "lcase"
      assert Mc.lookup(Mc.Modifier.Http, :post) == "urlp"
    end

    test "returns the longest name if multiple matches are found" do
      assert Mc.lookup(Mc.Modifier.Replace, :modify) == "replace"
    end

    test "returns nil for non existent module/func_atom pairs" do
      assert Mc.lookup(Does.Not, :exist) == nil
    end
  end

  defmodule TestMappingsStruct do
    defstruct [
      c23: {Foo.Bar, :biz},
      c2345: {Foo.Bar, :biz},
      c2: {Concert, :gig},
      c234: {Recipe, :cake}
    ]
  end

  describe "Mc.flatten/1" do
    test "returns `mappings` 'reversed/flattened' sorted (desc) by the length of characters in each key" do
      assert Mc.flatten(%TestMappingsStruct{}) == [
        {{Foo.Bar, :biz}, "c2345"},
        {{Recipe, :cake}, "c234"},
        {{Foo.Bar, :biz}, "c23"},
        {{Concert, :gig}, "c2"}
      ]
    end

    test "works with Maps" do
      map = %TestMappingsStruct{} |> Map.from_struct()

      assert Mc.flatten(map) == [
        {{Foo.Bar, :biz}, "c2345"},
        {{Recipe, :cake}, "c234"},
        {{Foo.Bar, :biz}, "c23"},
        {{Concert, :gig}, "c2"}
      ]
    end

    test "returns an empty list with an empty Map" do
      assert Mc.flatten(%{}) == []
    end
  end
end
