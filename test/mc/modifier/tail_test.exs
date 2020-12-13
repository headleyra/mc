defmodule Mc.Modifier.TailTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Tail

  describe "Mc.Modifier.Tail.modify/2" do
    test "returns the last `args` lines" do
      assert Tail.modify("one\ntwo\nthree", "1") == {:ok, "three"}
      assert Tail.modify("one\ntwo\nthree", "2") == {:ok, "two\nthree"}
      assert Tail.modify("one\ntwo\nthree", "3") == {:ok, "one\ntwo\nthree"}
      assert Tail.modify("one\ntwo\nthree", "4") == {:ok, "one\ntwo\nthree"}
      assert Tail.modify("one\ntwo\nthree\n", "3") == {:ok, "two\nthree\n"}
      assert Tail.modify("\none\n\ntwo\nthree\n\n", "5") == {:ok, "\ntwo\nthree\n\n"}
    end

    test "returns `buffer` if `args` exceeds lines present" do
      assert Tail.modify("one\ntwo", "19") == {:ok, "one\ntwo"}
    end

    test "returns empty string when `args` is zero" do
      assert Tail.modify("foo\nbar", "0") == {:ok, ""}
    end

    test "errors when `args` is negative" do
      assert Tail.modify("test\n123", "-1") == {:error, "usage: tail <positive integer>"}
      assert Tail.modify("foobar", "-11") == {:error, "usage: tail <positive integer>"}
    end

    test "errors when `args` is not an integer" do
      assert Tail.modify("test\n123", "hi") == {:error, "usage: tail <positive integer>"}
      assert Tail.modify("helicopter\ndrop", "four") == {:error, "usage: tail <positive integer>"}
    end

    test "works with ok tuples" do
      assert Tail.modify({:ok, "some\nbuffer\ntext"}, "2") == {:ok, "buffer\ntext"}
    end

    test "allows error tuples to pass-through" do
      assert Tail.modify({:error, "reason"}, "gets ignored") == {:error, "reason"}
    end
  end
end
