defmodule Mc.Modifier.SplitTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Split

  describe "Mc.Modifier.Split.modify/2" do
    test "splits the buffer by `args`" do
      assert Split.modify("one-two-three", "-") == {:ok, "one\ntwo\nthree"}
      assert Split.modify("= double == equals =", "=") == {:ok, "\n double \n\n equals \n"}
    end

    test "interprets `args` as a regular expression" do
      assert Split.modify("one two three", "[ ]") == {:ok, "one\ntwo\nthree"}
      assert Split.modify("= double == equals =", "( == )") == {:ok, "= double\nequals ="}
    end

    test "errors with a bad regular expression" do
      assert Split.modify("bish bosh", "[") == {:error, "usage: Mc.Modifier.Split#modify <regex>"}
    end

    test "works with ok tuples" do
      assert Split.modify({:ok, "best.of.3"}, "\\.") == {:ok, "best\nof\n3"}
    end

    test "allows error tuples to pass-through" do
      assert Split.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
