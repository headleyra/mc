defmodule Mc.Modifier.TailTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Tail

  describe "Mc.Modifier.Tail.modify/2" do
    test "parses `args` as an integer and returns that many lines from the end of `buffer`" do
      assert Tail.modify("one\ntwo\nthree", "1") == {:ok, "three"}
      assert Tail.modify("one\ntwo\nthree", "2") == {:ok, "two\nthree"}
      assert Tail.modify("one\ntwo\nthree", "3") == {:ok, "one\ntwo\nthree"}
      assert Tail.modify("one\ntwo\nthree", "4") == {:ok, "one\ntwo\nthree"}
      assert Tail.modify("one\ntwo\nthree\n", "3") == {:ok, "two\nthree\n"}
      assert Tail.modify("\none\n\ntwo\nthree\n\n", "5") == {:ok, "\ntwo\nthree\n\n"}
    end

    test "returns `buffer` if `args` exceeds lines present" do
      assert Tail.modify("one\ntwo", "3") == {:ok, "one\ntwo"}
      assert Tail.modify("just\nthis", "394") == {:ok, "just\nthis"}
    end

    test "returns empty string when `args` is zero" do
      assert Tail.modify("foo\nbar", "0") == {:ok, ""}
    end

    test "errors when `args` isn't a positive integer" do
      assert Tail.modify("123", "-1") == {:error, "Mc.Modifier.Tail#modify: negative or non-integer line count"}
      assert Tail.modify("", "3.1") == {:error, "Mc.Modifier.Tail#modify: negative or non-integer line count"}
      assert Tail.modify("oops", "hi") == {:error, "Mc.Modifier.Tail#modify: negative or non-integer line count"}
      assert Tail.modify("nowt", "") == {:error, "Mc.Modifier.Tail#modify: negative or non-integer line count"}
    end

    test "returns a help message" do
      assert Check.has_help?(Tail, :modify)
    end

    test "errors with unknown switches" do
      assert Tail.modify("", "--unknown") == {:error, "Mc.Modifier.Tail#modify: switch parse error"}
      assert Tail.modify("", "-u") == {:error, "Mc.Modifier.Tail#modify: switch parse error"}
    end

    test "works with ok tuples" do
      assert Tail.modify({:ok, "some\nbuffer\ntext"}, "2") == {:ok, "buffer\ntext"}
    end

    test "allows error tuples to pass through" do
      assert Tail.modify({:error, "reason"}, "gets ignored") == {:error, "reason"}
    end
  end
end
