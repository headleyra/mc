defmodule Mc.Modifier.JoinTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Join

  describe "Mc.Modifier.Join.modify/2" do
    test "joins lines in the buffer" do
      assert Join.modify(":un\n:deux\n:trois", "") == {:ok, ":un:deux:trois"}
      assert Join.modify("\t\t:un\n:deux\n:trois\n\n\t", "") == {:ok, "\t\t:un:deux:trois\t"}
      assert Join.modify("\n\n\n", "") == {:ok, ""}
    end

    test "joins lines separated by `args`" do
      assert Join.modify("one\ntwo\nthree", "--") == {:ok, "one--two--three"}
      assert Join.modify("\n double \n\n equals \n", "=") == {:ok, "= double == equals ="}
      assert Join.modify("\n\n\n", "A") == {:ok, "AAA"}
    end

    test "joins lines separated with URI-encoded `args`" do
      assert Join.modify("once\nupona\ntime", "%20") == {:ok, "once upona time"}
      assert Join.modify("bish\nbosh", "%09") == {:ok, "bish\tbosh"}
    end

    test "errors with bad URI-encoded `args`" do
      assert Join.modify("bish bosh", "%") == {:error, "usage: Mc.Modifier.Join#modify <URI-encoded separator>"}
    end

    test "works with ok tuples" do
      assert Join.modify({:ok, "best\nof\n3"}, "-") == {:ok, "best-of-3"}
    end

    test "allows error tuples to pass-through" do
      assert Join.modify({:error, "reason"}, "") == {:error, "reason"}
    end
  end
end
