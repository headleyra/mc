defmodule Mc.Modifier.SplitRTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.SplitR

  describe "m/3" do
    test "splits `buffer` on the regular expression in `args`" do
      assert SplitR.m("places\n\t   & spaces", "\\s+", %{}) == {:ok, "places\n&\nspaces"}
      assert SplitR.m("one two three", "[ ]", %{}) == {:ok, "one\ntwo\nthree"}
      assert SplitR.m("(foo)One(bar)Love(biz)", "\\(...\\)", %{}) == {:ok, "\nOne\nLove\n"}
    end

    test "splits buffer on whitespace by default" do
      assert SplitR.m("un deux trois", "", %{}) == {:ok, "un\ndeux\ntrois"}
      assert SplitR.m("foo    bar      biz", "", %{}) == {:ok, "foo\nbar\nbiz"}
      assert SplitR.m("mix \n it  \t up\n\n", "", %{}) == {:ok, "mix\nit\nup\n"}
    end

    test "errors with a bad regular expression" do
      assert SplitR.m("bish bosh", "[", %{}) == {:error, "Mc.Modifier.SplitR: bad regex"}
    end

    test "works with ok tuples" do
      assert SplitR.m({:ok, "best of 3"}, "[ ]", %{}) == {:ok, "best\nof\n3"}
    end

    test "allows error tuples to pass through" do
      assert SplitR.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
