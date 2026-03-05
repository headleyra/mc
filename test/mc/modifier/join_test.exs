defmodule Mc.Modifier.JoinTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Join

  describe "m/3" do
    test "joins lines in `buffer` and separates them with `args`" do
      assert Join.m("one\ntwo\nthree", "/", %{}) == {:ok, "one/two/three"}
      assert Join.m("\n double \n\n equals \n", "=", %{}) == {:ok, "= double == equals ="}
      assert Join.m("\n\n\n", "A", %{}) == {:ok, "AAA"}
      assert Join.m("foo\nbar", "%", %{}) == {:ok, "foo%bar"}
    end

    test "joins lines with no separator (by default)" do
      assert Join.m("un\ndeux\ntrois", "", %{}) == {:ok, "undeuxtrois"}
      assert Join.m("\t\tun\ndeux\ntrois\n\n\t", "", %{}) == {:ok, "\t\tundeuxtrois\t"}
      assert Join.m("\n\n\n", "", %{}) == {:ok, ""}
    end

    test "joins lines with URI-encoded `args`" do
      assert Join.m("once\nupon\na\ntime", "%20", %{}) == {:ok, "once upon a time"}
      assert Join.m("bish\nbosh", "%09", %{}) == {:ok, "bish\tbosh"}
    end

    test "works with ok tuples" do
      assert Join.m({:ok, "best\nof\n3"}, "-", %{}) == {:ok, "best-of-3"}
    end

    test "allows error tuples to pass through" do
      assert Join.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
