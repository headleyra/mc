defmodule Mc.Modifier.DeleteTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Delete

  describe "m/3" do
    test "interprets `args` as a regex and returns the `buffer` with matching terms deleted" do
      assert Delete.m("", "foo", %{}) == {:ok, ""}
      assert Delete.m("something", "foo", %{}) == {:ok, "something"}
      assert Delete.m("original", "al", %{}) == {:ok, "origin"}
      assert Delete.m("tennis is more than a game", ~S"mo.*a\s", %{}) == {:ok, "tennis is game"}
    end

    test "deletes multiple occurences" do
      assert Delete.m("bar means bar", "bar", %{}) == {:ok, " means "}

      times =
        """
        \t11:16\t[ABC]
        \t11:16\t[XYZ]
        """

      times_modified =
        """
        11:16\t[ABC]
        11:16\t[XYZ]
        """

      assert Delete.m(times, ~S"^\t", %{}) == {:ok, times_modified}
    end

    test "matches across newlines" do
      assert Delete.m("Tea\nis a great", ~S"Te.*is\s", %{}) == {:ok, "a great"}
      assert Delete.m("one\ntwo\ntwo", ~S"one.*?two", %{}) == {:ok, "\ntwo"}
    end

    test "handles greedy and non-greedy" do
      assert Delete.m("They're gre gre great!", ~S"They.*gre\s", %{}) == {:ok, "great!"}
      assert Delete.m("They're gre gre great!", ~S"They.*?gre\s", %{}) == {:ok, "gre great!"}
    end

    test "errors when the regex is bad" do
      assert Delete.m("one\ntwo", "?", %{}) == {:error, "Mc.Modifier.Delete: bad regex"}
    end

    test "works with ok tuples" do
      assert Delete.m({:ok, "chill on the beach"}, ~S"chill\s", %{}) == {:ok, "on the beach"}
    end

    test "allows error tuples to pass through" do
      assert Delete.m({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
