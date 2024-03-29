defmodule Mc.StringTest do
  use ExUnit.Case, async: true
  alias Mc.String

  describe "numberize/1" do
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

  describe "comment?/1" do
    test "returns true if `string` is a comment" do
      assert String.comment?("# this is a comment")
      assert String.comment?(" \t # so is this")
      assert String.comment?("#")
      assert String.comment?("# foobar #")
      assert String.comment?("\t# and this")
    end

    test "returns false when `string` isn't a comment" do
      refute String.comment?("this #is not a comment")
      refute String.comment?("no#r this")
    end
  end

  describe "grep/3" do
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

  describe "sort/2" do
    test "sorts the lines in `string` (ascending)" do
      assert String.sort("book\natom\ncar", ascending: true) == {:ok, "atom\nbook\ncar"}
    end

    test "sorts the lines in `string` (descending)" do
      assert String.sort("book\natom\ncar", ascending: false) == {:ok, "car\nbook\natom"}
    end
  end

  describe "to_num/1" do
    test "converts its argument to an integer" do
      assert String.to_num("0") == {:ok, 0}
      assert String.to_num("-2") == {:ok, -2}
      assert String.to_num("22") == {:ok, 22}
    end

    test "converts its argument to a float" do
      assert String.to_num("0.0") == {:ok, 0.0}
      assert String.to_num("-0.81") == {:ok, -0.81}
      assert String.to_num("3.142") == {:ok, 3.142}
    end

    test "errors for non-number strings" do
      assert String.to_num("") == :error
      assert String.to_num(".0") == :error
      assert String.to_num("apple") == :error
      assert String.to_num("%5") == :error
    end
  end

  describe "to_int/1" do
    test "converts its argument to an integer" do
      assert String.to_int("0") == {:ok, 0}
      assert String.to_int("-81") == {:ok, -81}
      assert String.to_int("5") == {:ok, 5}
    end

    test "errors for non-integer strings" do
      assert String.to_int("") == :error
      assert String.to_int("0.0") == :error
      assert String.to_int("beans") == :error
      assert String.to_int("^5") == :error
    end
  end

  describe "to_flt/1" do
    test "converts its argument to a float" do
      assert String.to_flt("0.0") == {:ok, 0.0}
      assert String.to_flt("-22.04") == {:ok, -22.04}
      assert String.to_flt("101.9") == {:ok, 101.9}
    end

    test "errors for non-float strings" do
      assert String.to_flt("") == :error
      assert String.to_flt("8") == :error
      assert String.to_flt("foo") == :error
      assert String.to_flt("3..2") == :error
      assert String.to_flt("4!6") == :error
    end
  end
end
