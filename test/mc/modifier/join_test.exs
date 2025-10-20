defmodule Mc.Modifier.JoinTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Join

  describe "modify/3" do
    test "joins lines in `buffer` and separates them with `args`" do
      assert Join.modify("one\ntwo\nthree", "/", %{}) == {:ok, "one/two/three"}
      assert Join.modify("\n double \n\n equals \n", "=", %{}) == {:ok, "= double == equals ="}
      assert Join.modify("\n\n\n", "A", %{}) == {:ok, "AAA"}
      assert Join.modify("foo\nbar", "%", %{}) == {:ok, "foo%bar"}
    end

    test "joins lines with no separator (by default)" do
      assert Join.modify("un\ndeux\ntrois", "", %{}) == {:ok, "undeuxtrois"}
      assert Join.modify("\t\tun\ndeux\ntrois\n\n\t", "", %{}) == {:ok, "\t\tundeuxtrois\t"}
      assert Join.modify("\n\n\n", "", %{}) == {:ok, ""}
    end

    test "joins lines with URI-encoded `args`" do
      assert Join.modify("once\nupon\na\ntime", "%20", %{}) == {:ok, "once upon a time"}
      assert Join.modify("bish\nbosh", "%09", %{}) == {:ok, "bish\tbosh"}
    end

    test "works with ok tuples" do
      assert Join.modify({:ok, "best\nof\n3"}, "-", %{}) == {:ok, "best-of-3"}
    end

    test "allows error tuples to pass through" do
      assert Join.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
