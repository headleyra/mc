defmodule Mc.Modifier.SplitRTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.SplitR

  describe "modify/3" do
    test "splits `buffer` on the regular expression in `args`" do
      assert SplitR.modify("places\n\t   & spaces", "\\s+", %{}) == {:ok, "places\n&\nspaces"}
      assert SplitR.modify("one two three", "[ ]", %{}) == {:ok, "one\ntwo\nthree"}
      assert SplitR.modify("(foo)One(bar)Love(biz)", "\\(...\\)", %{}) == {:ok, "\nOne\nLove\n"}
    end

    test "splits buffer on whitespace by default" do
      assert SplitR.modify("un deux trois", "", %{}) == {:ok, "un\ndeux\ntrois"}
      assert SplitR.modify("foo    bar      biz", "", %{}) == {:ok, "foo\nbar\nbiz"}
      assert SplitR.modify("mix \n it  \t up\n\n", "", %{}) == {:ok, "mix\nit\nup\n"}
    end

    test "errors with a bad regular expression" do
      assert SplitR.modify("bish bosh", "[", %{}) == {:error, "Mc.Modifier.SplitR: bad regex"}
    end

    test "works with ok tuples" do
      assert SplitR.modify({:ok, "best of 3"}, "[ ]", %{}) == {:ok, "best\nof\n3"}
    end

    test "allows error tuples to pass through" do
      assert SplitR.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
