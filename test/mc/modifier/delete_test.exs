defmodule Mc.Modifier.DeleteTest do
  use ExUnit.Case, async: true
  alias Mc.Modifier.Delete

  describe "modify/3" do
    test "interprets `args` as a regex and returns the `buffer` with matching terms deleted" do
      assert Delete.modify("", "foo", %{}) == {:ok, ""}
      assert Delete.modify("something", "foo", %{}) == {:ok, "something"}
      assert Delete.modify("original", "al", %{}) == {:ok, "origin"}
      assert Delete.modify("tennis is more than a game", ~S"mo.*a\s", %{}) == {:ok, "tennis is game"}
    end

    test "deletes multiple occurences" do
      assert Delete.modify("bar means bar", "bar", %{}) == {:ok, " means "}

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

      assert Delete.modify(times, ~S"^\t", %{}) == {:ok, times_modified}
    end

    test "matches across newlines" do
      assert Delete.modify("Tea\nis a great", ~S"Te.*is\s", %{}) == {:ok, "a great"}
      assert Delete.modify("one\ntwo\ntwo", ~S"one.*?two", %{}) == {:ok, "\ntwo"}
    end

    test "handles greedy and non-greedy" do
      assert Delete.modify("They're gre gre great!", ~S"They.*gre\s", %{}) == {:ok, "great!"}
      assert Delete.modify("They're gre gre great!", ~S"They.*?gre\s", %{}) == {:ok, "gre great!"}
    end

    test "errors when the regex is bad" do
      assert Delete.modify("one\ntwo", "?", %{}) == {:error, "Mc.Modifier.Delete#modify: bad regex"}
    end

    test "works with ok tuples" do
      assert Delete.modify({:ok, "chill on the beach"}, ~S"chill\s", %{}) == {:ok, "on the beach"}
    end

    test "allows error tuples to pass through" do
      assert Delete.modify({:error, "reason"}, "", %{}) == {:error, "reason"}
    end
  end
end
