defmodule Mc.Modifier.SplitTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Split

  describe "Mc.Modifier.Split.modify/2" do
    test "splits the buffer on `args`" do
      assert Split.modify("one-two-three", "-") == {:ok, "one\ntwo\nthree"}
      assert Split.modify("= double == equals =", "=") == {:ok, "\n double \n\n equals \n"}
    end

    test "splits the buffer on whitespace by default" do
      assert Split.modify("un deux trois", "") == {:ok, "un\ndeux\ntrois"}
      assert Split.modify("foo    bar      biz", "") == {:ok, "foo\nbar\nbiz"}
      assert Split.modify("mix \n it  \t up\n\n", "") == {:ok, "mix\nit\nup"}
    end

    test "parses `args` as a regular expression" do
      assert Split.modify("one two three", "[ ]") == {:ok, "one\ntwo\nthree"}
      assert Split.modify("= double == equals =", " == ") == {:ok, "= double\nequals ="}
    end

    test "errors with a bad regular expression" do
      assert Split.modify("bish bosh", "[") == {:error, "Mc.Modifier.Split#modify: bad regex"}
    end

    test "works with ok tuples" do
      assert Split.modify({:ok, "best-of-3"}, "-") == {:ok, "best\nof\n3"}
    end

    test "allows error tuples to pass through" do
      assert Split.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
