defmodule Mc.StringTest do
  use ExUnit.Case, async: true
  alias Mc.String

  describe "Mc.String.numberize/1" do
    test "converts its input into a list of numbers" do
      assert String.numberize("1") == {:ok, [1]}
      assert String.numberize("no numbers") == {:ok, []}
      assert String.numberize("") == {:ok, []}
      assert String.numberize(" \n\t ") == {:ok, []}
      assert String.numberize("cash 7") == {:ok, [7]}
      assert String.numberize("pi 3.142\nabc 123") == {:ok, [3.142, 123]}
      assert String.numberize("foo  -4.3\n2\t1\n0  bar") == {:ok, [-4.3, 2, 1, 0]}
    end
  end

  describe "Mc.String.is_comment?/1" do
    test "returns true if `string` is a comment" do
      assert String.is_comment?("# this is a comment")
      assert String.is_comment?(" \t # so is this")
      assert String.is_comment?("#")
      assert String.is_comment?("# foobar #")
      assert String.is_comment?("\t# and this")
    end

    test "returns false when `string` isn't a comment" do
      refute String.is_comment?("this #is not a comment")
      refute String.is_comment?("no#r this")
    end
  end

  describe "Mc.String.grep/3" do
    test "filters lines in `string` that match `regex_str`" do
      assert String.grep("one\ntwo\nthree", "o", match: true) == {:ok, "one\ntwo"}
      assert String.grep("one\ntwo\nthree", "nomatch", match: true) == {:ok, ""}
      assert String.grep("about\n\nmiddle\nBike", "[Bb].*[et]", match: true) == {:ok, "about\nBike"}
    end

    test "errors with bad regex (match)" do
      assert String.grep("foo", "*", match: true) == {:error, "bad regex"}
      assert String.grep("", "?", match: true) == {:error, "bad regex"}
    end

    test "filters lines in `string` that don't match `regex_str`" do
      assert String.grep("one\ntwo\nthree", "ee", match: false) == {:ok, "one\ntwo"}
      assert String.grep("one\ntwo\nthree", "nomatch", match: false) == {:ok, "one\ntwo\nthree"}
    end

    test "errors with bad regex (match inverse)" do
      assert String.grep("two", "*", match: false) == {:error, "bad regex"}
      assert String.grep("", "?", match: false) == {:error, "bad regex"}
    end
  end

  describe "Mc.String.sort/2" do
    test "sorts the lines in `string` (ascending)" do
      assert String.sort("book\natom\ncar", ascending: true) == {:ok, "atom\nbook\ncar"}
    end

    test "sorts the lines in `string` (descending)" do
      assert String.sort("book\natom\ncar", ascending: false) == {:ok, "car\nbook\natom"}
    end
  end

  describe "Mc.String.str2num/1" do
    test "converts its argument to an integer" do
      assert String.str2num("0") == {:ok, 0}
      assert String.str2num("-2") == {:ok, -2}
      assert String.str2num("22") == {:ok, 22}
    end

    test "converts its argument to a float" do
      assert String.str2num("0.0") == {:ok, 0.0}
      assert String.str2num("-0.81") == {:ok, -0.81}
      assert String.str2num("3.142") == {:ok, 3.142}
    end

    test "errors for non-number strings" do
      assert String.str2num("") == :error
      assert String.str2num(".0") == :error
      assert String.str2num("apple") == :error
      assert String.str2num("%5") == :error
    end
  end

  describe "Mc.String.str2int/1" do
    test "converts its argument to an integer" do
      assert String.str2int("0") == {:ok, 0}
      assert String.str2int("-81") == {:ok, -81}
      assert String.str2int("5") == {:ok, 5}
    end

    test "errors for non-integer strings" do
      assert String.str2int("") == :error
      assert String.str2int("0.0") == :error
      assert String.str2int("beans") == :error
      assert String.str2int("^5") == :error
    end
  end

  describe "Mc.String.str2flt/1" do
    test "converts its argument to a float" do
      assert String.str2flt("0.0") == {:ok, 0.0}
      assert String.str2flt("-22.04") == {:ok, -22.04}
      assert String.str2flt("101.9") == {:ok, 101.9}
    end

    test "errors for non-float strings" do
      assert String.str2flt("") == :error
      assert String.str2flt("8") == :error
      assert String.str2flt("foo") == :error
      assert String.str2flt("3..2") == :error
      assert String.str2flt("4!6") == :error
    end
  end
end
