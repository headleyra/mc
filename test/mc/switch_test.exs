defmodule Mc.SwitchTest do
  use ExUnit.Case, async: true
  alias Mc.Switch

  describe "Mc.Switch.parse/2" do
    test "parses its input into a 'command part' and a 'switches part' (given a list of 'switch specs')" do
      assert true
    end

    test "parses integer switches" do
      assert Switch.parse("-k 5", [{:konst, :integer, :k}]) == {"", [konst: 5]}
      assert Switch.parse("abc -i -7", [{:int, :integer, :i}]) == {"abc", [int: -7]}
      assert Switch.parse("abc -i 5 def", [{:int, :integer, :i}]) == {"abc def", [int: 5]}
      assert Switch.parse(" abc   -i   5    def", [{:int, :integer, :i}]) == {"abc def", [int: 5]}
    end

    test "parses boolean switches" do
      assert Switch.parse("-y foo bar", [{:yep, :boolean, :y}]) == {"foo bar", [yep: true]}
      assert Switch.parse("cmd -x", [{:yep, :boolean, :y}, {:ex, :boolean, :x}]) == {"cmd", [ex: true]}
      assert Switch.parse("cmd -x args", [{:yep, :boolean, :y}, {:ex, :boolean, :x}]) == {"cmd args", [ex: true]}
      assert Switch.parse("  cmd  -x   args ", [{:yep, :boolean, :y}, {:ex, :boolean, :x}]) == {"cmd args", [ex: true]}
    end

    test "parses float switches" do
      assert Switch.parse("-p 3.142 dosh", [{:pi, :float, :p}]) == {"dosh", [pi: 3.142]}
      assert Switch.parse("cash -p 3.142", [{:pi, :float, :p}]) == {"cash", [pi: 3.142]}
      assert Switch.parse("cash -p 3.142 money", [{:pi, :float, :p}]) == {"cash money", [pi: 3.142]}
      assert Switch.parse("  cash -p    3.142   money", [{:pi, :float, :p}]) == {"cash money", [pi: 3.142]}
    end

    test "parses string switches" do
      assert Switch.parse("-s 'all this' command", [{:str, :string, :s}]) == {"command", [str: "all this"]}
      assert Switch.parse("more -s howdy", [{:str, :string, :s}]) == {"more", [str: "howdy"]}
      assert Switch.parse("more -s howdy stuff", [{:str, :string, :s}]) == {"more stuff", [str: "howdy"]}
      assert Switch.parse(" more  -s  howdy stuff", [{:str, :string, :s}]) == {"more stuff", [str: "howdy"]}
    end

    test "parses multiple switches" do
      assert Switch.parse("cmd -i 5 -f 1.2 -b", [{:int, :integer, :i}, {:flt, :float, :f}, {:bln, :boolean, :b}]) ==
        {"cmd", [int: 5, flt: 1.2, bln: true]}
    end

    test "errors when the 'switch spec' list is bad" do
      assert Switch.parse("dosh", []) == :error
      assert Switch.parse("dosh", "") == :error
      assert Switch.parse("dosh", [{}]) == :error
      assert Switch.parse("dosh", [{:not, :a, :triple}]) == :error
      assert Switch.parse("dosh", [1, 3]) == :error
    end

    test "errors when there are 'unbalanced' single or double quote characters" do
      assert Switch.parse("'single", [{:single, :boolean, :s}]) == :error
      assert Switch.parse(" 'foo' ' ", [{:single, :boolean, :s}]) == :error
      assert Switch.parse("double\"", [{:double, :boolean, :d}]) == :error
      assert Switch.parse("\"word\" \"", [{:double, :boolean, :d}]) == :error
    end
  end

  describe "Mc.Switch.optionize/1" do
    test "converts a list of 'switch specs' into `OptionParser.parse/2` form" do
      assert Switch.optionize([{:switch_name, :integer, :x}]) ==
        {:ok, [strict: [switch_name: :integer], aliases: [x: :switch_name]]}

      assert Switch.optionize([{:aa, :boolean, :a}, {:bb, :string, :b}]) ==
        {:ok, [strict: [bb: :string, aa: :boolean], aliases: [b: :bb, a: :aa]]}
    end

    test "errors when any 'switch specs' aren't valid" do
      assert Switch.optionize([{:not, :a, :switch_spec}, {:ok, :boolean, :o}]) == :error
      assert Switch.optionize([]) == :error
      assert Switch.optionize([{}]) == :error
      assert Switch.optionize("nope") == :error
    end
  end

  describe "Mc.Switch.is_spec?/1" do
    test "returns false when its input isn't a valid 'switch spec' tuple" do
      assert Switch.is_spec?({"should be an atom", :integer, :b}) == false
      assert Switch.is_spec?({:avg, "should be a type atom", :s}) == false
      assert Switch.is_spec?({:book, :float, :should_be_one_char_long_atom}) == false
      assert Switch.is_spec?({:c, :type_is_not_valid, :d}) == false
      assert Switch.is_spec?({}) == false
      assert Switch.is_spec?([]) == false
      assert Switch.is_spec?("") == false
      assert Switch.is_spec?('abc') == false
    end

    test "returns true when its input is a valid 'switch spec' tuple" do
      assert Switch.is_spec?({:foo, :boolean, :a}) == true
      assert Switch.is_spec?({:bar, :integer, :b}) == true
      assert Switch.is_spec?({:biz, :float, :c}) == true
      assert Switch.is_spec?({:dosh, :string, :d}) == true
      assert Switch.is_spec?({:e, :string, :x}) == true
    end
  end
end
