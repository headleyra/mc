defmodule Mc.Modifier.SplitTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Split

  describe "modify/3" do
    test "splits `buffer` on the URI-encoded string in `args`" do
      assert Split.modify("one%two%three", "%25", %{}) == {:ok, "one\ntwo\nthree"}
      assert Split.modify(" marginal\t costs...\n", "%09%20", %{}) == {:ok, " marginal\ncosts...\n"}
      assert Split.modify("one, two, three\t", ",", %{}) == {:ok, "one\n two\n three\t"}
      assert Split.modify("one-love", "%09", %{}) == {:ok, "one-love"}
    end

    test "splits buffer on a single space by default" do
      assert Split.modify("un deux trois", "", %{}) == {:ok, "un\ndeux\ntrois"}
      assert Split.modify("\nfoo  bar   biz", "", %{}) == {:ok, "\nfoo\n\nbar\n\n\nbiz"}
      assert Split.modify("without-space", "", %{}) == {:ok, "without-space"}
    end

    test "works with ok tuples" do
      assert Split.modify({:ok, "best\tof\t3"}, "%09", %{}) == {:ok, "best\nof\n3"}
    end

    test "allows error tuples to pass through" do
      assert Split.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
