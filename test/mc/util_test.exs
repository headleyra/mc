defmodule Mc.UtilTest do
  use ExUnit.Case, async: true
  alias Mc.Util

  describe "Mc.Util.parse/2" do
    test "parses its input into a 'command part' and 'options part' (given `[{name, type, alias}, ...]`)" do
      true
    end

    test "parses integer options" do
      assert Util.parse("-k 5", [{:konst, :integer, :k}]) == {"", [konst: 5]}
      assert Util.parse("abc -i -7", [{:int, :integer, :i}]) == {"abc", [int: -7]}
      assert Util.parse("abc -i 5 def", [{:int, :integer, :i}]) == {"abc def", [int: 5]}
      assert Util.parse("   abc     -i   5    def", [{:int, :integer, :i}]) == {"abc def", [int: 5]}
    end

    test "parses boolean options" do
      assert Util.parse("-y foo bar", [{:yep, :boolean, :y}]) == {"foo bar", [yep: true]}
      assert Util.parse("cmd -x", [{:yep, :boolean, :y}, {:ex, :boolean, :x}]) == {"cmd", [ex: true]}
      assert Util.parse("cmd -x args", [{:yep, :boolean, :y}, {:ex, :boolean, :x}]) == {"cmd args", [ex: true]}
      assert Util.parse("  cmd  -x   args ", [{:yep, :boolean, :y}, {:ex, :boolean, :x}]) == {"cmd args", [ex: true]}
    end

    test "parses float options" do
      assert Util.parse("-p 3.142 dosh", [{:pi, :float, :p}]) == {"dosh", [pi: 3.142]}
      assert Util.parse("cash -p 3.142", [{:pi, :float, :p}]) == {"cash", [pi: 3.142]}
      assert Util.parse("cash -p 3.142 money", [{:pi, :float, :p}]) == {"cash money", [pi: 3.142]}
      assert Util.parse("   cash -p    3.142   money", [{:pi, :float, :p}]) == {"cash money", [pi: 3.142]}
    end

    test "parses string options" do
      assert Util.parse("-s 'all this' command", [{:str, :string, :s}]) == {"command", [str: "all this"]}
      assert Util.parse("more -s howdy", [{:str, :string, :s}]) == {"more", [str: "howdy"]}
      assert Util.parse("more -s howdy stuff", [{:str, :string, :s}]) == {"more stuff", [str: "howdy"]}
      assert Util.parse("   more   -s    howdy    stuff", [{:str, :string, :s}]) == {"more stuff", [str: "howdy"]}
    end

    test "parses multiple options" do
      assert Util.parse("cmd -i 5 -f 1.2 -b", [{:int, :integer, :i}, {:flt, :float, :f}, {:bln, :boolean, :b}]) ==
        {"cmd", [int: 5, flt: 1.2, bln: true]}
    end

    test "errors when the triple list is bad" do
      assert Util.parse("dosh", []) == :error
      assert Util.parse("dosh", "") == :error
      assert Util.parse("dosh", [{}]) == :error
      assert Util.parse("dosh", [{:not, :a, :triple}]) == :error
      assert Util.parse("dosh", [1, 3]) == :error
    end
  end

  describe "Mc.Util.parseify/1" do
    test "converts a list of 'triples' into `OptionParser.parse/2` form" do
      assert Util.parseify([{:option_name, :integer, :x}]) ==
        {:ok, [strict: [option_name: :integer], aliases: [x: :option_name]]}

      assert Util.parseify([{:aa, :boolean, :a}, {:bb, :string, :b}]) ==
        {:ok, [strict: [bb: :string, aa: :boolean], aliases: [b: :bb, a: :aa]]}
    end

    test "returns error when triples aren't valid" do
      assert Util.parseify([]) == :error
      assert Util.parseify([{}]) == :error
      assert Util.parseify("nope") == :error
      assert Util.parseify([{:not, :a, :triple}]) == :error
    end
  end

  describe "Mc.Util.is_triple?/1" do
    test "returns false when its input isn't a valid 'triple' tuple" do
      assert Util.is_triple?({"should be an atom", :integer, :b}) == false
      assert Util.is_triple?({:avg, "should be a type atom", :s}) == false
      assert Util.is_triple?({:book, :float, :should_be_one_char_long_atom}) == false
      assert Util.is_triple?({:c, :type_is_not_valid, :d}) == false
      assert Util.is_triple?({}) == false
      assert Util.is_triple?([]) == false
      assert Util.is_triple?("") == false
      assert Util.is_triple?('abc') == false
    end

    test "returns true when its input is a valid 'triple' tuple" do
      assert Util.is_triple?({:foo, :boolean, :a}) == true
      assert Util.is_triple?({:bar, :integer, :b}) == true
      assert Util.is_triple?({:biz, :float, :c}) == true
      assert Util.is_triple?({:dosh, :string, :d}) == true
      assert Util.is_triple?({:e, :string, :x}) == true
    end
  end
end
