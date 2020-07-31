defmodule Mc.Modifier.WrapTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Wrap

  describe "Mc.Modifier.Wrap.modify/2" do
    test "'wraps' `buffer` where `args` specifies the column to wrap at" do
      assert Wrap.modify("a bit of text", "5") == {:ok, "a bit\nof te\nxt"}
      assert Wrap.modify("testing \t 123", "5") == {:ok, "testi\nng \t1\n23"}
      assert Wrap.modify("\ntwo for the show\n123\n", "7") == {:ok, "\ntwo for\nthe sho\nw\n123\n"}
      assert Wrap.modify("\none\ntwo\nthree\n", "3") == {:ok, "\none\ntwo\nthr\nee\n"}
      assert Wrap.modify("\none\ntwo\nthree\n\n", "3") == {:ok, "\none\ntwo\nthr\nee\n\n"}
    end

    test "works with column wraps that look like integers" do
      assert Wrap.modify("a.long.word", "4a") == {:ok, "a.lo\nng.w\nord"}
      assert Wrap.modify("two words", "5.1") == {:ok, "two w\nords"}
    end

    test "returns an error tuple when `args` isn't a positive number" do
      assert Wrap.modify("a bit of text", "") == {:error, "Wrap: bad wrap number"}
      assert Wrap.modify("\ntesting\n123", "a5") == {:error, "Wrap: bad wrap number"}
      assert Wrap.modify("testing", "four") == {:error, "Wrap: bad wrap number"}
      assert Wrap.modify("foo", "-10") == {:error, "Wrap: bad wrap number"}
      assert Wrap.modify("bar", "0") == {:error, "Wrap: bad wrap number"}
    end

    test "works with ok tuples" do
      assert Wrap.modify({:ok, "best of 3"}, "7") == {:ok, "best of\n3"}
    end

    test "allows error tuples to pass-through unchanged" do
      assert Wrap.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end

  describe "Mc.Modifier.Wrap.wrap/2" do
    test "wraps `text` at the integer specified in `column`" do
      assert Wrap.wrap("a bit of text", 5) == "a bit\nof te\nxt"
      assert Wrap.wrap("testing \t 123", 5) == "testi\nng \t1\n23"
      assert Wrap.wrap("test 1234", 4) == "test\n1234"
    end

    test "returns newline given empty string" do
      assert Wrap.wrap("", 2_381) == ""
      assert Wrap.wrap("", 2) == ""
    end

    test "returns error when `column` isn't a positive number" do
      assert Wrap.wrap("foo", -8) == :error
      assert Wrap.wrap("bar", 0) == :error
    end
  end
end
